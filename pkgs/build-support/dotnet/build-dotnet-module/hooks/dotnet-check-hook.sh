# inherit arguments from derivation
dotnetTestFlags=( ${dotnetTestFlags[@]-} )

dotnetCheckHook() {
    echo "Executing dotnetCheckHook"

    runHook preCheck

    if [ "${disabledTests-}" ]; then
        local -r disabledTestsFlag="--filter @disabledTests@"
    fi

    if [ "${enableParallelBuilding-}" ]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
    else
        local -r maxCpuFlag="1"
    fi

    for project in ${testProjectFile[@]-${projectFile[@]}}; do
        env "LD_LIBRARY_PATH=@libraryPath@" \
            dotnet test "$project" \
              -maxcpucount:$maxCpuFlag \
              -p:ContinuousIntegrationBuild=true \
              -p:Deterministic=true \
              --configuration "@buildType@" \
              --no-build \
              --logger "console;verbosity=normal" \
              ${disabledTestsFlag-} \
              "${dotnetTestFlags[@]}"  \
              "${dotnetFlags[@]}"
    done

    runHook postCheck

    echo "Finished dotnetCheckHook"
}

if [[ -z "${dontDotnetCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase=dotnetCheckHook
fi
