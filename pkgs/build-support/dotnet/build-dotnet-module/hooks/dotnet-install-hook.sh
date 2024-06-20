dotnetInstallHook() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    local -r hostRuntimeId=@runtimeId@
    local -r dotnetInstallPath="${dotnetInstallPath-$out/lib/$pname}"
    local -r dotnetBuildType="${dotnetBuildType-Release}"
    local -r dotnetRuntimeId="${dotnetRuntimeId-$hostRuntimeId}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetInstallFlagsArray=( "${dotnetInstallFlags[@]}" )
        local dotnetPackFlagsArray=( "${dotnetPackFlags[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetInstallFlagsArray=($dotnetInstallFlags)
        local dotnetPackFlagsArray=($dotnetPackFlags)
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

    dotnetPublish() {
        local -r projectFile="${1-}"

        runtimeIdFlagsArray=()
        if [[ $projectFile == *.csproj || -n ${dotnetSelfContainedBuild-} ]]; then
            runtimeIdFlagsArray+=("--runtime" "$dotnetRuntimeId")
        fi

        dotnet publish ${1+"$projectFile"} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --output "$dotnetInstallPath" \
            --configuration "$dotnetBuildType" \
            --no-build \
            "${runtimeIdFlagsArray[@]}" \
            "${dotnetInstallFlagsArray[@]}" \
            "${dotnetFlagsArray[@]}"
    }

    dotnetPack() {
        local -r projectFile="${1-}"
        dotnet pack ${1+"$projectFile"} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --output "$out/share" \
            --configuration "$dotnetBuildType" \
            --no-build \
            --runtime "$dotnetRuntimeId" \
            "${dotnetPackFlagsArray[@]}" \
            "${dotnetFlagsArray[@]}"
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
