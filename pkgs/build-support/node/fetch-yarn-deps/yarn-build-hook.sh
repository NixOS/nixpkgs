yarnBuildHook() {
    runHook preBuild
    echo "Executing yarnBuildHook"

    if [ -z "${yarnBuildScript-}" ]; then
        yarnBuildScript="build"
    fi

    yarn --offline "$yarnBuildScript" \
        $yarnBuildFlags "${yarnBuildFlagsArray[@]}" \
        $yarnFlags "${yarnFlagsArray[@]}"

    echo "finished yarnBuildHook"
    runHook postBuild
}

if [[ -z "${dontYarnBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=yarnBuildHook
fi
