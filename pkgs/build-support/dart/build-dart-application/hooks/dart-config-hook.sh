# shellcheck shell=bash

dartConfigHook() {
    echo "Executing dartConfigHook"

    echo "Setting up SDK"
    eval "$sdkSetupScript"

    echo "Installing dependencies"
    eval doPubGet "$pubGetScript" --offline

    echo "Finished dartConfigHook"
}

postConfigureHooks+=(dartConfigHook)
