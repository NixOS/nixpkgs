# shellcheck shell=bash

npmBuildHook() {
    echo "Executing npmBuildHook"

    runHook preBuild

    if [ -z "${npmBuildScript-}" ]; then
        echo
        echo "ERROR: no build script was specified"
        echo 'Hint: set `npmBuildScript`, override `buildPhase`, or set `dontNpmBuild = true`.'
        echo

        exit 1
    fi

    if ! npm run ${npmWorkspace+--workspace=$npmWorkspace} "$npmBuildScript" $npmBuildFlags "${npmBuildFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}"; then
        echo
        echo 'ERROR: `npm build` failed'
        echo
        echo "Here are a few things you can try, depending on the error:"
        echo "1. Make sure your build script ($npmBuildScript) exists"
        echo '  If there is none, set `dontNpmBuild = true`.'
        echo '2. If the error being thrown is something similar to "error:0308010C:digital envelope routines::unsupported", add `NODE_OPTIONS = "--openssl-legacy-provider"` to your derivation'
        echo "  See https://github.com/webpack/webpack/issues/14532 for more information."
        echo

        exit 1
    fi

    runHook postBuild

    echo "Finished npmBuildHook"
}

if [ -z "${dontNpmBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=npmBuildHook
fi
