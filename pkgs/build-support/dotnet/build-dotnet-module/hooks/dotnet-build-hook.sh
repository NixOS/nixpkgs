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
        dotnetBuildFlags+=(--runtime "@runtimeId@" "-p:SelfContained=true")
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
        env dotnet build ${project-} \
            -maxcpucount:$maxCpuFlag \
            -p:BuildInParallel=$parallelBuildFlag \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --configuration "@buildType@" \
            --no-restore \
            ${versionFlag-} \
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
