# shellcheck shell=bash

dartConfigHook() {
    echo "Executing dartConfigHook"

    echo "Installing dependencies"
    eval doPubGet "$pubGetScript" --offline

    echo "Finished dartConfigHook"
}

postConfigureHooks+=(dartConfigHook)
