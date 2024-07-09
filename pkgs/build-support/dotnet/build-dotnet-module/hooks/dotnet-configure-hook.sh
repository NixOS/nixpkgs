dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    if [[ -z ${nugetSource-} ]]; then
        echo
        echo "ERROR: no dependencies were specified"
        echo 'Hint: set `nugetSource` if using these hooks individually. If this is happening with `buildDotnetModule`, please open an issue.'
        echo

        exit 1
    fi

    local nugetSourceSedQuoted="${nugetSource//[\/\\&$'\n']/\\&}"
    local nugetSourceXMLQuoted="$nugetSource"
    nugetSourceXMLQuoted="${nugetSource//&/\&amp;}"
    nugetSourceXMLQuoted="${nugetSourceXMLQuoted//\"/\&quot;}"

    local -r hostRuntimeId=@runtimeId@
    local -r dynamicLinker=@dynamicLinker@
    local -r libPath=@libPath@
    local -r dotnetRuntimeId="${dotnetRuntimeId-$hostRuntimeId}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetRestoreFlagsArray=( "${dotnetRestoreFlags[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetRestoreFlagsArray=($dotnetRestoreFlags)
    fi

    if [[ -z ${enableParallelBuilding-} ]]; then
        local -r parallelFlag="--disable-parallel"
    fi

    dotnetRestore() {
        local -r projectFile="${1-}"
        dotnet restore ${1+"$projectFile"} \
            -p:ContinuousIntegrationBuild=true \
            -p:Deterministic=true \
            --runtime "$dotnetRuntimeId" \
            --source "$nugetSource/lib" \
            ${parallelFlag-} \
            "${dotnetRestoreFlagsArray[@]}" \
            "${dotnetFlagsArray[@]}"
    }

    # Generate a NuGet.config file to make sure everything,
    # including things like <Sdk /> dependencies, is restored from the proper source
    cat >NuGet.config <<EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nugetSource" value="$nugetSourceXMLQuoted/lib" />
  </packageSources>
</configuration>
EOF

    # Patch paket.dependencies and paket.lock (if found) to use the proper
    # source. This ensures paket restore works correctly. Note that the
    # nugetSourceSedQuoted abomination below safely escapes nugetSource string
    # for use as a sed replacement string to avoid issues with slashes and other
    # special characters ('&', '\\' and '\n').
    find -name paket.dependencies -exec sed -i "s/source .*/source $nugetSourceSedQuoted\/lib/g" {} \;
    find -name paket.lock -exec sed -i "s/remote:.*/remote: $nugetSourceSedQuoted\/lib/g" {} \;

    dotnet tool restore --add-source "$nugetSource/lib"

    # dotnetGlobalTool is set in buildDotnetGlobalTool to patch dependencies but
    # avoid other project-specific logic. This is a hack, but the old behavior
    # is worse as it relied on a bug: setting projectFile to an empty string
    # made the hooks actually skip all project-specific logic. It’s hard to keep
    # backwards compatibility with this odd behavior now since we are using
    # arrays, so instead we just pass a variable to indicate that we don’t have
    # projects.
    if [[ -z ${dotnetGlobalTool-} ]]; then
        if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
            dotnetRestore
        fi

        local projectFile
        for projectFile in "${dotnetProjectFilesArray[@]}" "${dotnetTestProjectFilesArray[@]}"; do
            dotnetRestore "$projectFile"
        done
    fi

    echo "Fixing up native binaries..."
    # Find all native binaries and nuget libraries, and fix them up,
    # by setting the proper interpreter and rpath to some commonly used libraries
    local binary
    for binary in $(find "$HOME/.nuget/packages/" -type f -executable); do
        if patchelf --print-interpreter "$binary" >/dev/null 2>/dev/null; then
            echo "Found binary: $binary, fixing it up..."
            patchelf --set-interpreter "$(cat "$dynamicLinker")" "$binary"

            # This makes sure that if the binary requires some specific runtime dependencies, it can find it.
            # This fixes dotnet-built binaries like crossgen2
            patchelf \
                --add-needed libicui18n.so \
                --add-needed libicuuc.so \
                --add-needed libz.so \
                --add-needed libssl.so \
                "$binary"

            patchelf --set-rpath "$libPath" "$binary"
        fi
    done

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
