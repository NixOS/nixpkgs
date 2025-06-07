bunBuildHook() {
    runHook preBuild
    echo "Executing bunBuildHook"

    if [ -z "${bunBuildScript-}" ]; then
        bunBuildScript="build"
    fi

    if ! type node > /dev/null 2>&1 ; then
        echo bunConfigHook WARNING: a node interpreter was not added to the \
            build, and is probably required to run \'bun $bunBuildScript\'. \
            A common symptom of this is getting \'command not found\' errors \
            for Nodejs related tools.
    fi

    bun run $bunBuildScript $bunBuildFlags

    echo "finished bunBuildHook"
    runHook postBuild
}

if [[ -z "${dontBunBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=bunBuildHook
fi
