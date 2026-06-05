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
    concatTo pnpmBuildFlagsArray pnpmFlags pnpmBuildFlags


    echo
    echo "Running"
    echo "pnpm run ${pnpmWorkspacesArray[*]/#/--filter=} ${pnpmBuildScript:-build} ${pnpmBuildFlagsArray[*]}"
    echo

    if ! pnpm run "${pnpmWorkspacesArray[@]/#/--filter=}" "${pnpmBuildScript:-build}" "${pnpmBuildFlagsArray[@]}"; then
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
