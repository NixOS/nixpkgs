declare -a projectFile testProjectFile dotnetRestoreFlags dotnetFlags

dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    if [ -z "${enableParallelBuilding-}" ]; then
        parallelFlag="--disable-parallel"
    fi

    for project in ${projectFile[@]} ${testProjectFile[@]}; do
        env \
            dotnet restore "$project" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                --source "@nugetSource@/lib" \
                ${parallelFlag-} \
                "${dotnetRestoreFlags[@]}" \
                "${dotnetFlags[@]}"
    done

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
