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
        dotnet restore ${project-} \
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

    dotnet tool restore --add-source "@nugetSource@/lib"

    (( "${#projectFile[@]}" == 0 )) && dotnetRestore

    for project in ${projectFile[@]} ${testProjectFile[@]-}; do
        dotnetRestore "$project"
    done

    echo "Fixing up native binaries..."
    # Find all native binaries and nuget libraries, and fix them up,
    # by setting the proper interpreter and rpath to some commonly used libraries
    for binary in $(find "$HOME/.nuget/packages/" -type f -executable); do
        if patchelf --print-interpreter "$binary" >/dev/null 2>/dev/null; then
            echo "Found binary: $binary, fixing it up..."
            patchelf --set-interpreter "$(cat "@dynamicLinker@")" "$binary"

            # This makes sure that if the binary requires some specific runtime dependencies, it can find it.
            # This fixes dotnet-built binaries like crossgen2
            patchelf \
                --add-needed libicui18n.so \
                --add-needed libicuuc.so \
                --add-needed libz.so \
                --add-needed libssl.so \
                "$binary"

            patchelf --set-rpath "@libPath@" "$binary"
        fi
    done

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
