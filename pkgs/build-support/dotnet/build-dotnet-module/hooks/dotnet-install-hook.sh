# inherit arguments from derivation
dotnetInstallFlags=( ${dotnetInstallFlags[@]-} )

dotnetInstallHook() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    if [ "${selfContainedBuild-}" ]; then
        dotnetInstallFlags+=(--runtime "@runtimeId@" "--self-contained")
    else
        dotnetInstallFlags+=("--no-self-contained")
    fi

    if [ "${useAppHost-}" ]; then
        dotnetInstallFlags+=("-p:UseAppHost=true")
    fi

    dotnetPublish() {
        # TODO: Replace "-p:PublishDir" with "--output" when
        # upgrading dotnet-sdk_7 to a version > 7.0.200
        local -r project="${1-}"
        env dotnet publish ${project-} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            -p:PublishDir="$out/lib/${pname}" \
            --configuration "@buildType@" \
            --no-build \
            ${dotnetInstallFlags[@]}  \
            ${dotnetFlags[@]}
    }

    dotnetPack() {
        local -r project="${1-}"
        # TODO: Replace "-p:PackageOutputPath" with "--output" when
        # upgrading dotnet-sdk_7 to a version > 7.0.200
         env dotnet pack ${project-} \
             -p:ContinuousIntegrationBuild=true \
             -p:Deterministic=true \
             -p:PackageOutputPath="$out/share" \
             --configuration "@buildType@" \
             --no-build \
             ${dotnetPackFlags[@]}  \
             ${dotnetFlags[@]}
    }

    if (( "${#projectFile[@]}" == 0 )); then
        dotnetPublish
    else
        for project in ${projectFile[@]}; do
            dotnetPublish "$project"
        done
    fi

    if [[ "${packNupkg-}" ]]; then
        if (( "${#projectFile[@]}" == 0 )); then
            dotnetPack
        else
            for project in ${projectFile[@]}; do
                dotnetPack "$project"
            done
        fi
    fi

    runHook postInstall

    echo "Finished dotnetInstallHook"
}

if [[ -z "${dontDotnetInstall-}" && -z "${installPhase-}" ]]; then
    installPhase=dotnetInstallHook
fi
