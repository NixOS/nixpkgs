dotnetCheckHook() {
    echo "Executing dotnetCheckHook"

    runHook preCheck

    local -r dotnetBuildType="${dotnetBuildType-Release}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetTestFlagsArray=( "${dotnetTestFlags[@]}" )
        local dotnetTestFiltersArray=( "${dotnetTestFilters[@]}" )
        local dotnetDisabledTestsArray=( "${dotnetDisabledTests[@]}" )
        local dotnetRuntimeDepsArray=( "${dotnetRuntimeDeps[@]}" )
        local dotnetRuntimeIdsArray=( "${dotnetRuntimeIds[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetTestFlagsArray=($dotnetTestFlags)
        local dotnetTestFiltersArray=($dotnetTestFilters)
        local dotnetDisabledTestsArray=($dotnetDisabledTests)
        local dotnetRuntimeDepsArray=($dotnetRuntimeDeps)
        local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
    fi

    if (( ${#dotnetDisabledTestsArray[@]} > 0 )); then
        local disabledTestsFilters=("${dotnetDisabledTestsArray[@]/#/FullyQualifiedName!=}")
        dotnetTestFiltersArray=( "${dotnetTestFiltersArray[@]}" "${disabledTestsFilters[@]//,/%2C}" )
    fi

    if (( ${#dotnetTestFiltersArray[@]} > 0 )); then
        local OLDIFS="$IFS" IFS='&'
        dotnetTestFlagsArray+=("--filter:${dotnetTestFiltersArray[*]}")
        IFS="$OLDIFS"
    fi

    local libraryPath="${LD_LIBRARY_PATH-}"
    if (( ${#dotnetRuntimeDepsArray[@]} > 0 )); then
        local libraryPathArray=("${dotnetRuntimeDepsArray[@]/%//lib}")
        local OLDIFS="$IFS" IFS=':'
        libraryPath="${libraryPathArray[*]}${libraryPath:+':'}$libraryPath"
        IFS="$OLDIFS"
    fi

    if [[ -n ${enableParallelBuilding-} ]]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
    else
        local -r maxCpuFlag="1"
    fi

    local projectFile runtimeId
    for projectFile in "${dotnetTestProjectFilesArray[@]-${dotnetProjectFilesArray[@]}}"; do
        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            local runtimeIdFlagsArray=()
            if [[ $projectFile == *.csproj ]]; then
                runtimeIdFlagsArray=("--runtime" "$runtimeId")
            fi

            LD_LIBRARY_PATH=$libraryPath \
                dotnet test "$projectFile" \
                -maxcpucount:"$maxCpuFlag" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                --configuration "$dotnetBuildType" \
                --no-restore \
                --no-build \
                --logger "console;verbosity=normal" \
                "${runtimeIdFlagsArray[@]}" \
                "${dotnetTestFlagsArray[@]}" \
                "${dotnetFlagsArray[@]}"
        done
    done

    runHook postCheck

    echo "Finished dotnetCheckHook"
}

if [[ -z "${dontDotnetCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase=dotnetCheckHook
fi
