dotnetConfigureHook() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

    local -r dynamicLinker=@dynamicLinker@
    local -r libPath=@libPath@

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetRestoreFlagsArray=( "${dotnetRestoreFlags[@]}" )
        local dotnetRuntimeIdsArray=( "${dotnetRuntimeIds[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetRestoreFlagsArray=($dotnetRestoreFlags)
        local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
    fi

    if [[ -z ${enableParallelBuilding-} ]]; then
        local -r parallelFlag="--disable-parallel"
    fi

    dotnetRestore() {
        local -r projectFile="${1-}"
        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            dotnet restore ${1+"$projectFile"} \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:NuGetAudit=false \
                --runtime "$runtimeId" \
                ${parallelFlag-} \
                "${dotnetRestoreFlagsArray[@]}" \
                "${dotnetFlagsArray[@]}"
        done
    }

    find -iname nuget.config -print0 | while IFS= read -rd "" config; do
        if [[ -n "${keepNugetConfig-}" ]]; then
            # If we're keeping the existing configs, we'll add _nix everywhere,
            # in case sources are cleared.
            dotnet nuget add source "$nugetSource" -n _nix --configfile "$config"
        else
            # This will allow everything to fall through to our config in the
            # build root. Deleting them causes some build failures.
            xq -xi '.configuration={}' "$config"
        fi
    done

    if [[ -f .config/dotnet-tools.json || -f .dotnet-tools.json ]]; then
        dotnet tool restore
    fi

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

    runHook postConfigure

    echo "Finished dotnetConfigureHook"
}

if [[ -z "${dontDotnetConfigure-}" && -z "${configurePhase-}" ]]; then
    configurePhase=dotnetConfigureHook
fi
