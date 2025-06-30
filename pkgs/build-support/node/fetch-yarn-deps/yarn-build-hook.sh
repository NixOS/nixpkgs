yarnBuildHook() {
    runHook preBuild
    echo "Executing yarnBuildHook"

    if [ -z "${yarnBuildScript-}" ]; then
        yarnBuildScript="build"
    fi

    if ! type node > /dev/null 2>&1 ; then
        echo yarnConfigHook WARNING: a node interpreter was not added to the \
            build, and is probably required to run \'yarn $yarnBuildHook\'. \
            A common symptom of this is getting \'command not found\' errors \
            for Nodejs related tools.
    fi

    yarn --offline "$yarnBuildScript" $yarnBuildFlags

    echo "finished yarnBuildHook"
    runHook postBuild
}

if [[ -z "${dontYarnBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=yarnBuildHook
fi
