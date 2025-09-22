dubBuildHook() {
    runHook preBuild
    echo "Executing dubBuildHook"

    dub build --skip-registry=all --build="${dubBuildType-"release"}" "${dubBuildFlags[@]}" "${dubFlags[@]}"

    echo "Finished dubBuildHook"
    runHook postBuild
}

if [[ -z "${dontDubBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=dubBuildHook
fi
