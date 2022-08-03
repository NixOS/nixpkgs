# inherit arguments from derivation
dotnetBuildFlags=( ${dotnetBuildFlags[@]-} )

dotnetBuildHook() {
    echo "Executing dotnetBuildHook"

    runHook preBuild

    if [ "${enableParallelBuilding-}" ]; then
        maxCpuFlag="$NIX_BUILD_CORES"
        parallelBuildFlag="true"
    else
        maxCpuFlag="1"
        parallelBuildFlag="false"
    fi

    if [ "${selfContainedBuild-}" ]; then
        dotnetBuildFlags+=("-p:SelfContained=true")
    else
        dotnetBuildFlags+=("-p:SelfContained=false")
    fi

    if [ "${version-}" ]; then
        versionFlag="-p:Version=${version-}"
    fi

    for project in ${projectFile[@]} ${testProjectFile[@]}; do
        env \
            dotnet build "$project" \
                -maxcpucount:$maxCpuFlag \
                -p:BuildInParallel=$parallelBuildFlag \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:UseAppHost=true \
                --configuration "@buildType@" \
                --no-restore \
                ${versionFlag-} \
                ${dotnetBuildFlags[@]}  \
                ${dotnetFlags[@]}
    done

    runHook postBuild

    echo "Finished dotnetBuildHook"
}

if [[ -z "${dontDotnetBuild-}" && -z "${buildPhase-}" ]]; then
    buildPhase=dotnetBuildHook
fi
