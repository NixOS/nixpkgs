declare -a projectFile testProjectFile

# Inherit arguments from derivation
dotnetFlags=( ${dotnetFlags[@]-} )
dotnetRestoreFlags=( ${dotnetRestoreFlags[@]-} )

dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    if [ -z "${enableParallelBuilding-}" ]; then
        parallelFlag="--disable-parallel"
    fi

    if [ -z "${dontSetNugetSource-}" ]; then
        nugetSourceFlag="--source @nugetSource@/lib"
    fi

    if [ "${generateLockfile-}" ]; then
        lockfilePath="$HOME/lockfile.json"
        lockfileFlag="--use-lock-file --lock-file-path ${lockfilePath}"
    fi

    for project in ${projectFile[@]} ${testProjectFile[@]}; do
        env \
            dotnet restore "$project" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                ${nugetSourceFlag-} \
                ${lockfileFlag-} \
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
