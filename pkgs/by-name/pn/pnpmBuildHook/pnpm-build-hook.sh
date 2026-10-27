# shellcheck shell=bash

pnpmBuildHook() {
    echo "Executing pnpmBuildHook"

    if [[ $pnpmRoot ]]; then
      pushd "$pnpmRoot"
    fi

    # Add workspace flags before the other flags
    local -a pnpmWorkspacesArray
    concatTo pnpmWorkspacesArray pnpmWorkspaces

    local -a pnpmBuildFlagsArray
    concatTo pnpmBuildFlagsArray pnpmBuildFlags

    local -a pnpmFlagsArray
    concatTo pnpmFlagsArray pnpmFlags

    # You cannot combine bash formatting operators unfortunately.
    local -r buildScript="${pnpmBuildScript:-build}"
    local -r workspacesArray=("${pnpmWorkspacesArray[@]/#/--filter=}")

    echo
    echo "Running"
    echo "pnpm ${pnpmFlagsArray[*]@Q} run ${workspacesArray[*]@Q} ${buildScript@Q} ${pnpmBuildFlagsArray[*]@Q}"
    echo

    if ! pnpm "${pnpmFlagsArray[@]}" run "${workspacesArray[@]}" "${buildScript}" "${pnpmBuildFlagsArray[@]}"; then
        echo
        echo "ERROR: 'pnpm run ${pnpmBuildScript:-build}' failed"
        echo
        echo "Here are a few things you can try, depending on the error:"
        echo "1. Make sure your build script (${pnpmBuildScript:-build}) exists"
        echo '   If there isnt one, set `dontPnpmBuild = true`.'
        echo

        exit 1
    fi

    if [[ $pnpmRoot ]]; then
      popd
    fi

    echo "Finished pnpmBuildHook"
}

pnpmBuildPhase() {
  runHook preBuild

  pnpmBuildHook

  runHook postBuild
}

if [ -z "${dontPnpmBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=pnpmBuildPhase
fi
