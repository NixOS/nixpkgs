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
        dotnetBuildFlags+=("-p:SelfContained=true")
    else
        dotnetBuildFlags+=("-p:SelfContained=false")
    fi

    if [ "${useAppHost-}" ]; then
        dotnetBuildFlags+=("-p:UseAppHost=true")
    fi

    local versionFlags=()
    if [ "${version-}" ]; then
        versionFlags+=("-p:InformationalVersion=${version-}")
    fi

    if [ "${versionForDotnet-}" ]; then
        versionFlags+=("-p:Version=${versionForDotnet-}")
    fi

    dotnetBuild() {
        local -r project="${1-}"

        runtimeIdFlags=()
        if [[ "$project" == *.csproj ]] || [ "${selfContainedBuild-}" ]; then
            runtimeIdFlags+=("--runtime @runtimeId@")
        fi

        dotnet build ${project-} \
            -maxcpucount:$maxCpuFlag \
            -p:BuildInParallel=$parallelBuildFlag \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --configuration "@buildType@" \
            --no-restore \
            ${versionFlags[@]} \
            ${runtimeIdFlags[@]} \
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
