dubBuildHook() {
    runHook preBuild
    echo "Executing dubBuildHook"

    local flagsArray=(
        --skip-registry=all
        "--build=${dubBuildType-release}"
    )
    concatTo flagsArray dubBuildFlags dubFlags

    echoCmd 'dubBuildHook flags' "${flagsArray[@]}"
    dub build "${flagsArray[@]}"

    echo "Finished dubBuildHook"
    runHook postBuild
}

if [[ -z "${dontDubBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=dubBuildHook
fi
