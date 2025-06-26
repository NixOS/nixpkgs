dotnetConfigurePhase() {
    echo "Executing dotnetConfigureHook"

    runHook preConfigure

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

    if [[ -v dotnetSelfContainedBuild ]]; then
        if [[ -n $dotnetSelfContainedBuild ]]; then
            dotnetRestoreFlagsArray+=("-p:SelfContained=true")
        else
            dotnetRestoreFlagsArray+=("-p:SelfContained=false")
        fi
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

    if [[ -f .config/dotnet-tools.json || -f dotnet-tools.json ]]; then
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
    configurePhase=dotnetConfigurePhase
fi

dotnetBuildPhase() {
    echo "Executing dotnetBuildHook"

    runHook preBuild

    local -r dotnetBuildType="${dotnetBuildType-Release}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetTestProjectFilesArray=( "${dotnetTestProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetBuildFlagsArray=( "${dotnetBuildFlags[@]}" )
        local dotnetRuntimeIdsArray=( "${dotnetRuntimeIds[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetTestProjectFilesArray=($dotnetTestProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetBuildFlagsArray=($dotnetBuildFlags)
        local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
    fi

    if [[ -n "${enableParallelBuilding-}" ]]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
        local -r parallelBuildFlag="true"
    else
        local -r maxCpuFlag="1"
        local -r parallelBuildFlag="false"
    fi

    if [[ -v dotnetSelfContainedBuild ]]; then
        if [[ -n $dotnetSelfContainedBuild ]]; then
            dotnetBuildFlagsArray+=("-p:SelfContained=true")
        else
            dotnetBuildFlagsArray+=("-p:SelfContained=false")
        fi
    fi

    if [[ -n ${dotnetUseAppHost-} ]]; then
        dotnetBuildFlagsArray+=("-p:UseAppHost=true")
    fi

    local versionFlagsArray=()
    if [[ -n ${version-} ]]; then
        versionFlagsArray+=("-p:InformationalVersion=$version")
    fi

    if [[ -n ${versionForDotnet-} ]]; then
        versionFlagsArray+=("-p:Version=$versionForDotnet")
    fi

    dotnetBuild() {
        local -r projectFile="${1-}"

        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            local runtimeIdFlagsArray=()
            if [[ $projectFile == *.csproj || -n ${dotnetSelfContainedBuild-} ]]; then
                runtimeIdFlagsArray+=("--runtime" "$runtimeId")
            fi

            dotnet build ${1+"$projectFile"} \
                -maxcpucount:"$maxCpuFlag" \
                -p:BuildInParallel="$parallelBuildFlag" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:OverwriteReadOnlyFiles=true \
                --configuration "$dotnetBuildType" \
                --no-restore \
                "${versionFlagsArray[@]}" \
                "${runtimeIdFlagsArray[@]}" \
                "${dotnetBuildFlagsArray[@]}" \
                "${dotnetFlagsArray[@]}"
        done
    }

    if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
        dotnetBuild
    fi

    local projectFile
    for projectFile in "${dotnetProjectFilesArray[@]}" "${dotnetTestProjectFilesArray[@]}"; do
        dotnetBuild "$projectFile"
    done

    runHook postBuild

    echo "Finished dotnetBuildHook"
}

if [[ -z ${dontDotnetBuild-} && -z ${buildPhase-} ]]; then
    buildPhase=dotnetBuildPhase
fi

dotnetCheckPhase() {
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
    checkPhase=dotnetCheckPhase
fi

# For compatibility, convert makeWrapperArgs to an array unless we are using
# structured attributes. That is, we ensure that makeWrapperArgs is always an
# array.
# See https://github.com/NixOS/nixpkgs/blob/858f4db3048c5be3527e183470e93c1a72c5727c/pkgs/build-support/dotnet/build-dotnet-module/hooks/dotnet-fixup-hook.sh#L1-L3
# and https://github.com/NixOS/nixpkgs/pull/313005#issuecomment-2175482920
if [[ -z $__structuredAttrs ]]; then
    makeWrapperArgs=( ${makeWrapperArgs-} )
fi

# First argument is the executable you want to wrap,
# the second is the destination for the wrapper.
wrapDotnetProgram() {
    local -r dotnetRuntime=@dotnetRuntime@
    local -r wrapperPath=@wrapperPath@

    local -r dotnetFromEnvScript='dotnetFromEnv() {
    local dotnetPath
    if command -v dotnet 2>&1 >/dev/null; then
        dotnetPath=$(which dotnet) && \
            dotnetPath=$(realpath "$dotnetPath") && \
            dotnetPath=$(dirname "$dotnetPath") && \
            export DOTNET_ROOT="$dotnetPath"
    fi
}
dotnetFromEnv'

    if [[ -n $__structuredAttrs ]]; then
        local -r dotnetRuntimeDepsArray=( "${dotnetRuntimeDeps[@]}" )
    else
        local -r dotnetRuntimeDepsArray=($dotnetRuntimeDeps)
    fi

    local dotnetRuntimeDepsFlags=()
    if (( ${#dotnetRuntimeDepsArray[@]} > 0 )); then
        local libraryPathArray=("${dotnetRuntimeDepsArray[@]/%//lib}")
        local OLDIFS="$IFS" IFS=':'
        dotnetRuntimeDepsFlags+=("--suffix" "LD_LIBRARY_PATH" ":" "${libraryPathArray[*]}")
        IFS="$OLDIFS"
    fi

    local dotnetRootFlagsArray=()
    if [[ -z ${dotnetSelfContainedBuild-} ]]; then
        if [[ -n ${useDotnetFromEnv-} ]]; then
            # if dotnet CLI is available, set DOTNET_ROOT based on it. Otherwise set to default .NET runtime
            dotnetRootFlagsArray+=("--suffix" "PATH" ":" "$wrapperPath")
            dotnetRootFlagsArray+=("--run" "$dotnetFromEnvScript")
            if [[ -n $dotnetRuntime ]]; then
                dotnetRootFlagsArray+=("--set-default" "DOTNET_ROOT" "$dotnetRuntime/share/dotnet")
                dotnetRootFlagsArray+=("--suffix" "PATH" ":" "$dotnetRuntime/bin")
            fi
        elif [[ -n $dotnetRuntime ]]; then
            dotnetRootFlagsArray+=("--set" "DOTNET_ROOT" "$dotnetRuntime/share/dotnet")
            dotnetRootFlagsArray+=("--prefix" "PATH" ":" "$dotnetRuntime/bin")
        fi
    fi

    makeWrapper "$1" "$2" \
        "${dotnetRuntimeDepsFlags[@]}" \
        "${dotnetRootFlagsArray[@]}" \
        "${gappsWrapperArgs[@]}" \
        "${makeWrapperArgs[@]}"

    echo "installed wrapper to "$2""
}

dotnetFixupPhase() {
    local -r dotnetInstallPath="${dotnetInstallPath-$out/lib/$pname}"

    local executable executableBasename

    # check if dotnetExecutables is declared (including empty values, in which case we generate no executables)
    if declare -p dotnetExecutables &>/dev/null; then
        if [[ -n $__structuredAttrs ]]; then
            local dotnetExecutablesArray=( "${dotnetExecutables[@]}" )
        else
            local dotnetExecutablesArray=($dotnetExecutables)
        fi
        for executable in "${dotnetExecutablesArray[@]}"; do
            executableBasename=$(basename "$executable")

            local path="$dotnetInstallPath/$executable"

            if test -x "$path"; then
                wrapDotnetProgram "$path" "$out/bin/$executableBasename"
            else
                echo "Specified binary \"$executable\" is either not an executable or does not exist!"
                echo "Looked in $path"
                exit 1
            fi
        done
    else
        while IFS= read -d '' executable; do
            executableBasename=$(basename "$executable")
            wrapDotnetProgram "$executable" "$out/bin/$executableBasename" \;
        done < <(find "$dotnetInstallPath" ! -name "*.dll" -executable -type f -print0)
    fi
}

if [[ -z "${dontFixup-}" && -z "${dontDotnetFixup-}" ]]; then
    appendToVar preFixupPhases dotnetFixupPhase
fi

dotnetInstallPhase() {
    echo "Executing dotnetInstallHook"

    runHook preInstall

    local -r dotnetInstallPath="${dotnetInstallPath-$out/lib/$pname}"
    local -r dotnetBuildType="${dotnetBuildType-Release}"

    if [[ -n $__structuredAttrs ]]; then
        local dotnetProjectFilesArray=( "${dotnetProjectFiles[@]}" )
        local dotnetFlagsArray=( "${dotnetFlags[@]}" )
        local dotnetInstallFlagsArray=( "${dotnetInstallFlags[@]}" )
        local dotnetPackFlagsArray=( "${dotnetPackFlags[@]}" )
        local dotnetRuntimeIdsArray=( "${dotnetRuntimeIds[@]}" )
    else
        local dotnetProjectFilesArray=($dotnetProjectFiles)
        local dotnetFlagsArray=($dotnetFlags)
        local dotnetInstallFlagsArray=($dotnetInstallFlags)
        local dotnetPackFlagsArray=($dotnetPackFlags)
        local dotnetRuntimeIdsArray=($dotnetRuntimeIds)
    fi

    if [[ -v dotnetSelfContainedBuild ]]; then
        if [[ -n $dotnetSelfContainedBuild ]]; then
            dotnetInstallFlagsArray+=("--self-contained")
        else
            dotnetInstallFlagsArray+=("--no-self-contained")
            # https://learn.microsoft.com/en-us/dotnet/core/deploying/trimming/trim-self-contained
            # Trimming is only available for self-contained build, so force disable it here
            dotnetInstallFlagsArray+=("-p:PublishTrimmed=false")
        fi
    fi

    if [[ -n ${dotnetUseAppHost-} ]]; then
        dotnetInstallFlagsArray+=("-p:UseAppHost=true")
    fi

    if [[ -n ${enableParallelBuilding-} ]]; then
        local -r maxCpuFlag="$NIX_BUILD_CORES"
    else
        local -r maxCpuFlag="1"
    fi

    dotnetPublish() {
        local -r projectFile="${1-}"

        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            runtimeIdFlagsArray=()
            if [[ $projectFile == *.csproj || -n ${dotnetSelfContainedBuild-} ]]; then
                runtimeIdFlagsArray+=("--runtime" "$runtimeId")
            fi

            dotnet publish ${1+"$projectFile"} \
                -maxcpucount:"$maxCpuFlag" \
                -p:ContinuousIntegrationBuild=true \
                -p:Deterministic=true \
                -p:OverwriteReadOnlyFiles=true \
                --output "$dotnetInstallPath" \
                --configuration "$dotnetBuildType" \
                --no-restore \
                --no-build \
                "${runtimeIdFlagsArray[@]}" \
                "${dotnetInstallFlagsArray[@]}" \
                "${dotnetFlagsArray[@]}"
        done
    }

    dotnetPack() {
        local -r projectFile="${1-}"

        for runtimeId in "${dotnetRuntimeIdsArray[@]}"; do
            dotnet pack ${1+"$projectFile"} \
                   -maxcpucount:"$maxCpuFlag" \
                   -p:ContinuousIntegrationBuild=true \
                   -p:Deterministic=true \
                   -p:OverwriteReadOnlyFiles=true \
                   --output "$out/share/nuget/source" \
                   --configuration "$dotnetBuildType" \
                   --no-restore \
                   --no-build \
                   --runtime "$runtimeId" \
                   "${dotnetPackFlagsArray[@]}" \
                   "${dotnetFlagsArray[@]}"
        done
    }

    if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
        dotnetPublish
    else
        local projectFile
        for projectFile in "${dotnetProjectFilesArray[@]}"; do
            dotnetPublish "$projectFile"
        done
    fi

    if [[ -n ${packNupkg-} ]]; then
        if (( ${#dotnetProjectFilesArray[@]} == 0 )); then
            dotnetPack
        else
            local projectFile
            for projectFile in "${dotnetProjectFilesArray[@]}"; do
                dotnetPack "$projectFile"
            done
        fi
    fi

    runHook postInstall

    echo "Finished dotnetInstallHook"
}

if [[ -z "${dontDotnetInstall-}" && -z "${installPhase-}" ]]; then
    installPhase=dotnetInstallPhase
fi
