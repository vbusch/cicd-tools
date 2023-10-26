#!/usr/bin/env bash

# Mock functions
podman() {
    echo "Podman version 99"
}

docker() {
    echo "Docker version 99"
}

load_cicd_helper_functions() {

    local CICD_CONTAINER_PREFER_ENGINE='docker'
    local LIBRARY_TO_LOAD=${1:-all}
    
    if [ "CI" != "true" ]; then
        CICD_BOOTSTRAP_ROOTDIR=.
        CICD_BOOTSTRAP_SKIP_GIT_CLONE=1
        CICD_BOOTSTRAP_SKIP_CLEANUP=1
        source src/bootstrap.sh "$LIBRARY_TO_LOAD"
    else
        if [ "$GITHUB_HEAD_REF" != "main" ]; then
            CICD_BOOTSTRAP_SKIP_GIT_CLONE=1
            CICD_BOOTSTRAP_ROOTDIR=.
        fi
        source src/bootstrap.sh "$LIBRARY_TO_LOAD"
    fi
}

load_cicd_helper_functions container

EXPECTED_OUTPUT=$(cicd::container::cmd --version)

# Assert there's an actual output
if ! [ "Docker version 99" == "$EXPECTED_OUTPUT" ]; then
    echo "container preference not working!"
    exit 1
fi

load_cicd_helper_functions container

# Assert output doesn't change 
if ! [ "$(cicd::container::cmd --version)" == "$EXPECTED_OUTPUT" ]; then
    echo "Container command not preserved between runs!"
    exit 1
fi

if ! [ "$(cicd::container::cmd --version)" == "$EXPECTED_OUTPUT" ]; then
    echo "Container command not preserved between runs!"
    exit 1
fi
