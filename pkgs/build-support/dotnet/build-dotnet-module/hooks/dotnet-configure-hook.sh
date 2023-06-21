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
            --runtime "@runtimeId@" \
            --source "@nugetSource@/lib" \
            ${parallelFlag-} \
            ${dotnetRestoreFlags[@]} \
            ${dotnetFlags[@]}
    }

    # Generate a NuGet.config file to make sure everything,
    # including things like <Sdk /> dependencies, is restored from the proper source
cat <<EOF > "./NuGet.config"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nugetSource" value="@nugetSource@/lib" />
  </packageSources>
</configuration>
EOF

    # Patch paket.dependencies and paket.lock (if found) to use the proper source. This ensures
    # paket restore works correctly
    # We use + instead of / in sed to avoid problems with slashes
    find -name paket.dependencies -exec sed -i 's+source .*+source @nugetSource@/lib+g' {} \;
    find -name paket.lock -exec sed -i 's+remote:.*+remote: @nugetSource@/lib+g' {} \;

    env dotnet tool restore --add-source "@nugetSource@/lib"

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
