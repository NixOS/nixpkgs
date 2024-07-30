dotnetCheckHook() {
    echo "Executing dotnetCheckHook"

    runHook preCheck

    local -r hostRuntimeId=@runtimeId@
    local -r dotnetBuildType="${dotnetBuildType-Release}"
    local -r dotnetRuntimeId="${dotnetRuntimeId-$hostRuntimeId}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetTestFlagsArray=( "${dotnetTestFlags[@]}" )
        local dotnetDisabledTestsArray=( "${dotnetDisabledTests[@]}" )
        local dotnetRuntimeDepsArray=( "${dotnetRuntimeDeps[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetTestFlagsArray=($dotnetTestFlags)
        local dotnetDisabledTestsArray=($dotnetDisabledTests)
        local dotnetRuntimeDepsArray=($dotnetRuntimeDeps)
    fi

    if (( ${#dotnetDisabledTestsArray[@]} > 0 )); then
        local disabledTestsFilters=("${dotnetDisabledTestsArray[@]/#/FullyQualifiedName!=}")
        local OLDIFS="$IFS" IFS='&'
        dotnetTestFlagsArray+=("--filter:${disabledTestsFilters[*]//,/%2C}")
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

    local projectFile
    for projectFile in "${dotnetTestProjectFilesArray[@]-${dotnetProjectFilesArray[@]}}"; do
        local runtimeIdFlagsArray=()
        if [[ $projectFile == *.csproj ]]; then
            runtimeIdFlagsArray=("--runtime" "$dotnetRuntimeId")
        fi

        LD_LIBRARY_PATH=$libraryPath \
            dotnet test "$projectFile" \
              -maxcpucount:"$maxCpuFlag" \
              -p:ContinuousIntegrationBuild=true \
              -p:Deterministic=true \
              --configuration "$dotnetBuildType" \
              --no-build \
              --logger "console;verbosity=normal" \
              "${runtimeIdFlagsArray[@]}" \
              "${dotnetTestFlagsArray[@]}" \
              "${dotnetFlagsArray[@]}"
    done

    runHook postCheck

    echo "Finished dotnetCheckHook"
}

if [[ -z "${dontDotnetCheck-}" && -z "${checkPhase-}" ]]; then
    checkPhase=dotnetCheckHook
fi
