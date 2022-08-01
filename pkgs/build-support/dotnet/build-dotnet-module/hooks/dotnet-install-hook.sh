# inherit arguments from derivation
dotnetInstallFlags=( ${dotnetInstallFlags[@]-} )

dotnetInstallHook() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    if [ "${selfContainedBuild-}" ]; then
        dotnetInstallFlags+=("--self-contained")
    else
        dotnetInstallFlags+=("--no-self-contained")
    fi

    for project in ${projectFile[@]}; do
        env \
            dotnet publish "$project" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:UseAppHost=true \
                --output "$out/lib/${pname}" \
                --configuration "@buildType@" \
                --no-build \
                ${dotnetInstallFlags[@]}  \
                ${dotnetFlags[@]}
    done

    if [[ "${packNupkg-}" ]]; then
        for project in ${projectFile[@]}; do
            env \
                dotnet pack "$project" \
                    -p:ContinuousIntegrationBuild=true \
                    -p:Deterministic=true \
                    --output "$out/share" \
                    --configuration "@buildType@" \
                    --no-build \
                    ${dotnetPackFlags[@]}  \
                    ${dotnetFlags[@]}
        done
    fi

    runHook postInstall

    echo "Finished dotnetInstallHook"
}

if [[ -z "${dontDotnetInstall-}" && -z "${installPhase-}" ]]; then
    installPhase=dotnetInstallHook
fi
