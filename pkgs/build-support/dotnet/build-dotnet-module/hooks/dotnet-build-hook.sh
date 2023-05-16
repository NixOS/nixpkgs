# inherit arguments from derivation
dotnetBuildFlags=( ${dotnetBuildFlags[@]-} )

dotnetBuildHook() {
    echo "Executing dotnetBuildHook"

    runHook preBuild

    if [ "${enableParallelBuilding-}" ]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
        local -r parallelBuildFlag="true"
    else
        local -r maxCpuFlag="1"
        local -r parallelBuildFlag="false"
    fi

    if [ "${selfContainedBuild-}" ]; then
<<<<<<< HEAD
        dotnetBuildFlags+=("-p:SelfContained=true")
=======
        dotnetBuildFlags+=(--runtime "@runtimeId@" "-p:SelfContained=true")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    else
        dotnetBuildFlags+=("-p:SelfContained=false")
    fi

    if [ "${useAppHost-}" ]; then
        dotnetBuildFlags+=("-p:UseAppHost=true")
    fi

    if [ "${version-}" ]; then
        local -r versionFlag="-p:Version=${version-}"
    fi

    dotnetBuild() {
        local -r project="${1-}"
<<<<<<< HEAD

        runtimeIdFlags=()
        if [[ "$project" == *.csproj ]] || [ "${selfContainedBuild-}" ]; then
            runtimeIdFlags+=("--runtime @runtimeId@")
        fi

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        env dotnet build ${project-} \
            -maxcpucount:$maxCpuFlag \
            -p:BuildInParallel=$parallelBuildFlag \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --configuration "@buildType@" \
            --no-restore \
            ${versionFlag-} \
<<<<<<< HEAD
            ${runtimeIdFlags[@]} \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            ${dotnetBuildFlags[@]}  \
            ${dotnetFlags[@]}
    }

    (( "${#projectFile[@]}" == 0 )) && dotnetBuild

    for project in ${projectFile[@]} ${testProjectFile[@]-}; do
        dotnetBuild "$project"
    done

    runHook postBuild

    echo "Finished dotnetBuildHook"
}

if [[ -z "${dontDotnetBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=dotnetBuildHook
fi
