dotnetBuildHook() {
    echo "Executing dotnetBuildHook"

    runHook preBuild

    local -r hostRuntimeId=@runtimeId@
    local -r dotnetBuildType="${dotnetBuildType-Release}"
    local -r dotnetRuntimeId="${dotnetRuntimeId-$hostRuntimeId}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetBuildFlagsArray=( "${dotnetBuildFlags[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetBuildFlagsArray=($dotnetBuildFlags)
    fi

    if [[ -n "${enableParallelBuilding-}" ]]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
        local -r parallelBuildFlag="true"
    else
        local -r maxCpuFlag="1"
        local -r parallelBuildFlag="false"
    fi

    if [[ -n ${dotnetSelfContainedBuild-} ]]; then
        dotnetBuildFlagsArray+=("-p:SelfContained=true")
    else
        dotnetBuildFlagsArray+=("-p:SelfContained=false")
    fi

    if [[ -n ${dotnetUseAppHost-} ]]; then
        dotnetBuildFlagsArray+=("-p:UseAppHost=true")
    fi

    local versionFlagsArray=()
    if [[ -n ${version-} ]]; then
        versionFlagsArray+=("-p:InformationalVersion=$version")
    fi

    if [[ -n ${versionForDotnet-} ]]; then
        versionFlagsArray+=("-p:Version=$versionForDotnet")
    fi

    dotnetBuild() {
        local -r projectFile="${1-}"

        local runtimeIdFlagsArray=()
        if [[ $projectFile == *.csproj || -n ${dotnetSelfContainedBuild-} ]]; then
            runtimeIdFlagsArray+=("--runtime" "$dotnetRuntimeId")
        fi

        dotnet build ${1+"$projectFile"} \
            -maxcpucount:"$maxCpuFlag" \
            -p:BuildInParallel="$parallelBuildFlag" \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --configuration "$dotnetBuildType" \
            --no-restore \
            "${versionFlagsArray[@]}" \
            "${runtimeIdFlagsArray[@]}" \
            "${dotnetBuildFlagsArray[@]}" \
            "${dotnetFlagsArray[@]}"
    }

    if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
        dotnetBuild
    fi

    local projectFile
    for projectFile in "${dotnetProjectFilesArray[@]}" "${dotnetTestProjectFilesArray[@]}"; do
        dotnetBuild "$projectFile"
    done

    runHook postBuild

    echo "Finished dotnetBuildHook"
}

if [[ -z ${dontDotnetBuild-} && -z ${buildPhase-} ]]; then
    buildPhase=dotnetBuildHook
fi
