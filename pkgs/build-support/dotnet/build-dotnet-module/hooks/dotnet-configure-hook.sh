declare -a projectFile testProjectFile

# inherit arguments from derivation
dotnetFlags=( ${dotnetFlags[@]-} )
dotnetRestoreFlags=( ${dotnetRestoreFlags[@]-} )

dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    if [ -z "${enableParallelBuilding-}" ]; then
        parallelFlag="--disable-parallel"
    fi

    if [ -z "${dontDotnetSetNugetSource}" ]; then
        nugetSourceFlag="--source \"@nugetSource@/lib\""
    fi

    for project in ${projectFile[@]} ${testProjectFile[@]}; do
        env \
            dotnet restore "$project" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                ${nugetSourceFlag-} \
                ${parallelFlag-} \
                ${dotnetRestoreFlags[@]} \
                ${dotnetFlags[@]}
    done

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
