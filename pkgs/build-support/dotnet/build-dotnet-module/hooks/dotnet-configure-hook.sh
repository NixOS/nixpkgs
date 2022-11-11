declare -a projectFile testProjectFile

# Inherit arguments from derivation
dotnetFlags=( ${dotnetFlags[@]-} )
dotnetRestoreFlags=( ${dotnetRestoreFlags[@]-} )

dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    if [ -z "${enableParallelBuilding-}" ]; then
        local -r parallelFlag="--disable-parallel"
    fi

    dotnetRestore() {
        local -r project="${1-}"
        env dotnet restore ${project-} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --source "@nugetSource@/lib" \
            ${parallelFlag-} \
            ${dotnetRestoreFlags[@]} \
            ${dotnetFlags[@]}
    }

    (( "${#projectFile[@]}" == 0 )) && dotnetRestore

    for project in ${projectFile[@]} ${testProjectFile[@]-}; do
        dotnetRestore "$project"
    done

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
