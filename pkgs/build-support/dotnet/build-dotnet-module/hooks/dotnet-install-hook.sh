# inherit arguments from derivation
dotnetInstallFlags=( ${dotnetInstallFlags[@]-} )

dotnetInstallHook() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    if [ "${selfContainedBuild-}" ]; then
<<<<<<< HEAD
        dotnetInstallFlags+=("--self-contained")
    else
        dotnetInstallFlags+=("--no-self-contained")
        # https://learn.microsoft.com/en-us/dotnet/core/deploying/trimming/trim-self-contained
        # Trimming is only available for self-contained build, so force disable it here
        dotnetInstallFlags+=("-p:PublishTrimmed=false")
=======
        dotnetInstallFlags+=(--runtime "@runtimeId@" "--self-contained")
    else
        dotnetInstallFlags+=("--no-self-contained")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fi

    if [ "${useAppHost-}" ]; then
        dotnetInstallFlags+=("-p:UseAppHost=true")
    fi

    dotnetPublish() {
        local -r project="${1-}"
<<<<<<< HEAD

        runtimeIdFlags=()
        if [[ "$project" == *.csproj ]] || [ "${selfContainedBuild-}" ]; then
            runtimeIdFlags+=("--runtime @runtimeId@")
        fi

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        env dotnet publish ${project-} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --output "$out/lib/${pname}" \
            --configuration "@buildType@" \
            --no-build \
<<<<<<< HEAD
            ${runtimeIdFlags[@]} \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            ${dotnetInstallFlags[@]}  \
            ${dotnetFlags[@]}
    }

    dotnetPack() {
        local -r project="${1-}"
<<<<<<< HEAD
        env dotnet pack ${project-} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --output "$out/share" \
            --configuration "@buildType@" \
            --no-build \
            --runtime "@runtimeId@" \
            ${dotnetPackFlags[@]}  \
            ${dotnetFlags[@]}
=======
         env dotnet pack ${project-} \
             -p:ContinuousIntegrationBuild=true \
             -p:Deterministic=true \
             --output "$out/share" \
             --configuration "@buildType@" \
             --no-build \
             ${dotnetPackFlags[@]}  \
             ${dotnetFlags[@]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
