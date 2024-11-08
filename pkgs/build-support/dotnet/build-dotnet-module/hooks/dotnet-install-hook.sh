dotnetInstallHook() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    local -r dotnetInstallPath="${dotnetInstallPath-$out/lib/$pname}"
    local -r dotnetBuildType="${dotnetBuildType-Release}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetInstallFlagsArray=( "${dotnetInstallFlags[@]}" )
        local dotnetPackFlagsArray=( "${dotnetPackFlags[@]}" )
        local dotnetRuntimeIdsArray=( "${dotnetRuntimeIds[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetInstallFlagsArray=($dotnetInstallFlags)
        local dotnetPackFlagsArray=($dotnetPackFlags)
        local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
    fi

    if [[ -n ${dotnetSelfContainedBuild-} ]]; then
        dotnetInstallFlagsArray+=("--self-contained")
    else
        dotnetInstallFlagsArray+=("--no-self-contained")
        # https://learn.microsoft.com/en-us/dotnet/core/deploying/trimming/trim-self-contained
        # Trimming is only available for self-contained build, so force disable it here
        dotnetInstallFlagsArray+=("-p:PublishTrimmed=false")
    fi

    if [[ -n ${dotnetUseAppHost-} ]]; then
        dotnetInstallFlagsArray+=("-p:UseAppHost=true")
    fi

    if [[ -n ${enableParallelBuilding-} ]]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
    else
        local -r maxCpuFlag="1"
    fi

    dotnetPublish() {
        local -r projectFile="${1-}"

        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            runtimeIdFlagsArray=()
            if [[ $projectFile == *.csproj || -n ${dotnetSelfContainedBuild-} ]]; then
                runtimeIdFlagsArray+=("--runtime" "$runtimeId")
            fi

            dotnet publish ${1+"$projectFile"} \
                -maxcpucount:"$maxCpuFlag" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:OverwriteReadOnlyFiles=true \
                --output "$dotnetInstallPath" \
                --configuration "$dotnetBuildType" \
                --no-restore \
                --no-build \
                "${runtimeIdFlagsArray[@]}" \
                "${dotnetInstallFlagsArray[@]}" \
                "${dotnetFlagsArray[@]}"
        done
    }

    dotnetPack() {
        local -r projectFile="${1-}"

        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            dotnet pack ${1+"$projectFile"} \
                   -maxcpucount:"$maxCpuFlag" \
                   -p:ContinuousIntegrationBuild=true \
                   -p:Deterministic=true \
                   -p:OverwriteReadOnlyFiles=true \
                   --output "$out/share/nuget/source" \
                   --configuration "$dotnetBuildType" \
                   --no-restore \
                   --no-build \
                   --runtime "$runtimeId" \
                   "${dotnetPackFlagsArray[@]}" \
                   "${dotnetFlagsArray[@]}"
        done
    }

    if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
        dotnetPublish
    else
        local projectFile
        for projectFile in "${dotnetProjectFilesArray[@]}"; do
            dotnetPublish "$projectFile"
        done
    fi

    if [[ -n ${packNupkg-} ]]; then
        if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
            dotnetPack
        else
            local projectFile
            for projectFile in "${dotnetProjectFilesArray[@]}"; do
                dotnetPack "$projectFile"
            done
        fi
    fi

    runHook postInstall

    echo "Finished dotnetInstallHook"
}

if [[ -z "${dontDotnetInstall-}" && -z "${installPhase-}" ]]; then
    installPhase=dotnetInstallHook
fi
