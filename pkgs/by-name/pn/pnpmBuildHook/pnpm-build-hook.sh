# shellcheck shell=bash

pnpmBuildHook() {
    echo "Executing pnpmBuildHook"

    runHook preBuild

    if [[ ! -v pnpmBuildScript ]]; then
        echo
        echo "WARN: no build script was specified"
        echo "Defaulting to script 'build'"
        echo

    fi

    local -a pnpmBuildFlagsArray
    concatTo pnpmBuildFlagsArray pnpmFlags pnpmBuildFlags

    echo
    echo "Running"
    echo "pnpm run ${pnpmBuildScript:-build} ${pnpmBuildFlagsArray[@]}"
    echo

    if ! pnpm run "${pnpmBuildScript:-build}" "${pnpmBuildFlagsArray[@]}"; then
        echo
        echo 'ERROR: `pnpm build` failed'
        echo
        echo "Here are a few things you can try, depending on the error:"
        echo "1. Make sure your build script ($pnpmBuildScript) exists"
        echo '   If there isnt one, set `dontPnpmBuild = true`.'
        echo

        exit 1
    fi

    runHook postBuild

    echo "Finished pnpmBuildHook"
}

if [ -z "${dontPnpmBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=pnpmBuildHook
fi
