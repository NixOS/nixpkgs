#!/usr/bin/env bash

bunBuildHook() {
    runHook preBuild
    echo "Executing bunBuildHook"

    if [ -z "${bunBuildScript-}" ]; then
        bunBuildScript="build"
    fi

    if ! type node > /dev/null 2>&1; then
        echo "bunConfigHook WARNING: a node interpreter was not added to the build, and is probably required to run 'bun $bunBuildScript'. A common symptom of this is getting 'command not found' errors for Nodejs related tools."
    fi

    # shellcheck disable=SC2154
    # SC2154: bunBuildFlags is referenced but not assigned
    # This variable is provided by the Nix build environment, not assigned in this script
    if [[ -n "${bunBuildFlags-}" ]]; then
        bun run "$bunBuildScript" "${bunBuildFlags[@]}"
    else
        bun run "$bunBuildScript"
    fi

    echo "finished bunBuildHook"
    runHook postBuild
}

if [[ -z "${dontBunBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=bunBuildHook
fi
