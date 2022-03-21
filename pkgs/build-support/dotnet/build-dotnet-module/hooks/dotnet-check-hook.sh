declare -a testProjectFile dotnetTestFlags dotnetFlags

dotnetCheckHook() {
    echo "Executing dotnetCheckHook"

    runHook preCheck

    if [ "${disabledTests-}" ]; then
        disabledTestsFlag="--filter FullyQualifiedName!=@disabledTests@"
    fi

    for project in ${testProjectFile[@]}; do
        env \
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
