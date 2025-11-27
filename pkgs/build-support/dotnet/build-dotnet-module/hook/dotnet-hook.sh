# shellcheck shell=bash

_dotnetIsSolution() {
  dotnet sln ${1:+"$1"} list 2>/dev/null
}

dotnetConfigurePhase() {
  echo "Executing dotnetConfigureHook"

  runHook preConfigure

  local -a projectFiles flags runtimeIds
  concatTo projectFiles dotnetProjectFiles dotnetTestProjectFiles
  concatTo flags dotnetFlags dotnetRestoreFlags
  concatTo runtimeIds dotnetRuntimeIds

  if [[ -z ${enableParallelBuilding-} ]]; then
    flags+=(--disable-parallel)
  fi

  if [[ -v dotnetSelfContainedBuild ]]; then
    if [[ -n $dotnetSelfContainedBuild ]]; then
      flags+=("-p:SelfContained=true")
    else
      flags+=("-p:SelfContained=false")
    fi
  fi

  dotnetRestore() {
    local -r projectFile="${1-}"

    local useRuntime=
    _dotnetIsSolution "$projectFile" || useRuntime=1

    for runtimeId in "${runtimeIds[@]}"; do
      local runtimeIdFlags=()
      if [[ -n $useRuntime ]]; then
        runtimeIdFlags+=("--runtime" "$runtimeId")
      fi

      dotnet restore ${1+"$projectFile"} \
             -p:ContinuousIntegrationBuild=true \
             -p:Deterministic=true \
             -p:NuGetAudit=false \
             "${runtimeIdFlags[@]}" \
             "${flags[@]}"
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
    if (( ${#projectFiles[@]} == 0 )); then
      dotnetRestore
    fi

    local projectFile
    for projectFile in "${projectFiles[@]}"; do
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

  local -a projectFiles flags runtimeIds
  concatTo projectFiles dotnetProjectFiles dotnetTestProjectFiles
  concatTo flags dotnetFlags dotnetBuildFlags
  concatTo runtimeIds dotnetRuntimeIds

  if [[ -n "${enableParallelBuilding-}" ]]; then
    local -r maxCpuFlag="$NIX_BUILD_CORES"
    local -r parallelBuildFlag="true"
  else
    local -r maxCpuFlag="1"
    local -r parallelBuildFlag="false"
  fi

  if [[ -v dotnetSelfContainedBuild ]]; then
    if [[ -n $dotnetSelfContainedBuild ]]; then
      flags+=("-p:SelfContained=true")
    else
      flags+=("-p:SelfContained=false")
    fi
  fi

  if [[ -n ${dotnetUseAppHost-} ]]; then
    flags+=("-p:UseAppHost=true")
  fi

  if [[ -n ${version-} ]]; then
    flags+=("-p:InformationalVersion=$version")
  fi

  if [[ -n ${versionForDotnet-} ]]; then
    flags+=("-p:Version=$versionForDotnet")
  fi

  dotnetBuild() {
    local -r projectFile="${1-}"

    local useRuntime=
    _dotnetIsSolution "$projectFile" || useRuntime=1

    for runtimeId in "${runtimeIds[@]}"; do
      local runtimeIdFlags=()
      if [[ -n $useRuntime ]]; then
        runtimeIdFlags+=("--runtime" "$runtimeId")
      fi

      dotnet build ${1+"$projectFile"} \
             -maxcpucount:"$maxCpuFlag" \
             -p:BuildInParallel="$parallelBuildFlag" \
             -p:ContinuousIntegrationBuild=true \
             -p:Deterministic=true \
             -p:OverwriteReadOnlyFiles=true \
             --configuration "$dotnetBuildType" \
             --no-restore \
             "${runtimeIdFlags[@]}" \
             "${flags[@]}"
    done
  }

  if (( ${#projectFiles[@]} == 0 )); then
    dotnetBuild
  fi

  local projectFile
  for projectFile in "${projectFiles[@]}"; do
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

  local -a projectFiles testProjectFiles testFilters disabledTests flags runtimeIds runtimeDeps
  concatTo projectFiles dotnetProjectFiles
  concatTo testProjectFiles dotnetTestProjectFiles
  concatTo testFilters dotnetTestFilters
  concatTo disabledTests dotnetDisabledTests
  concatTo flags dotnetFlags dotnetTestFlags
  concatTo runtimeIds dotnetRuntimeIds
  concatTo runtimeDeps dotnetRuntimeDeps

  if (( ${#disabledTests[@]} > 0 )); then
    local disabledTestsFilters=("${disabledTests[@]/#/FullyQualifiedName!=}")
    testFilters=( "${testFilters[@]}" "${disabledTestsFilters[@]//,/%2C}" )
  fi

  if (( ${#testFilters[@]} > 0 )); then
    local OLDIFS="$IFS" IFS='&'
    flags+=("--filter:${testFilters[*]}")
    IFS="$OLDIFS"
  fi

  local libraryPath="${LD_LIBRARY_PATH-}"
  if (( ${#runtimeDeps[@]} > 0 )); then
    local libraryPaths=("${runtimeDeps[@]/%//lib}")
    local OLDIFS="$IFS" IFS=':'
    libraryPath="${libraryPaths[*]}${libraryPath:+':'}$libraryPath"
    IFS="$OLDIFS"
  fi

  if [[ -n ${enableParallelBuilding-} ]]; then
    local -r maxCpuFlag="$NIX_BUILD_CORES"
  else
    local -r maxCpuFlag="1"
  fi

  local projectFile runtimeId
  for projectFile in "${testProjectFiles[@]-${projectFiles[@]}}"; do
    local useRuntime=
    _dotnetIsSolution "$projectFile" || useRuntime=1

    for runtimeId in "${runtimeIds[@]}"; do
      local runtimeIdFlags=()
      if [[ -n $useRuntime ]]; then
        runtimeIdFlags=("--runtime" "$runtimeId")
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
        "${runtimeIdFlags[@]}" \
        "${flags[@]}"
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
# shellcheck disable=2206
if [[ -z $__structuredAttrs ]]; then
  makeWrapperArgs=( ${makeWrapperArgs-} )
fi

# First argument is the executable you want to wrap,
# the second is the destination for the wrapper.
wrapDotnetProgram() {
  local -r dotnetRuntime=@dotnetRuntime@
  local -r wrapperPath=@wrapperPath@

  # shellcheck disable=2016
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

  # shellcheck disable=2206
  local -a runtimeDeps
  concatTo runtimeDeps dotnetRuntimeDeps

  local wrapperFlags=()
  if (( ${#runtimeDeps[@]} > 0 )); then
    local libraryPath=("${runtimeDeps[@]/%//lib}")
    local OLDIFS="$IFS" IFS=':'
    wrapperFlags+=("--suffix" "LD_LIBRARY_PATH" ":" "${libraryPath[*]}")
    IFS="$OLDIFS"
  fi

  if [[ -z ${dotnetSelfContainedBuild-} ]]; then
    if [[ -n ${useDotnetFromEnv-} ]]; then
      # if dotnet CLI is available, set DOTNET_ROOT based on it. Otherwise set to default .NET runtime
      wrapperFlags+=("--suffix" "PATH" ":" "$wrapperPath")
      wrapperFlags+=("--run" "$dotnetFromEnvScript")
      if [[ -n $dotnetRuntime ]]; then
        wrapperFlags+=("--set-default" "DOTNET_ROOT" "$dotnetRuntime/share/dotnet")
        wrapperFlags+=("--suffix" "PATH" ":" "$dotnetRuntime/bin")
      fi
    elif [[ -n $dotnetRuntime ]]; then
      wrapperFlags+=("--set" "DOTNET_ROOT" "$dotnetRuntime/share/dotnet")
      wrapperFlags+=("--prefix" "PATH" ":" "$dotnetRuntime/bin")
    fi
  fi

  # shellcheck disable=2154
  makeWrapper "$1" "$2" \
              "${wrapperFlags[@]}" \
              "${gappsWrapperArgs[@]}" \
              "${makeWrapperArgs[@]}"

  echo "installed wrapper to $2"
}

dotnetFixupPhase() {
  local -r dotnetInstallPath="${dotnetInstallPath-$out/lib/$pname}"

  local executable executableBasename

  # check if dotnetExecutables is declared (including empty values, in which case we generate no executables)
  # shellcheck disable=2154
  if declare -p dotnetExecutables &>/dev/null; then
    # shellcheck disable=2206
    local -a executables
    concatTo executables dotnetExecutables
    for executable in "${executables[@]}"; do
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
    while IFS= read -r -d '' executable; do
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

  local -a projectFiles flags installFlags packFlags runtimeIds
  concatTo projectFiles dotnetProjectFiles
  concatTo flags dotnetFlags
  concatTo installFlags dotnetInstallFlags
  concatTo packFlags dotnetPackFlags
  concatTo runtimeIds dotnetRuntimeIds

  if [[ -v dotnetSelfContainedBuild ]]; then
    if [[ -n $dotnetSelfContainedBuild ]]; then
      installFlags+=("--self-contained")
    else
      installFlags+=("--no-self-contained")
      # https://learn.microsoft.com/en-us/dotnet/core/deploying/trimming/trim-self-contained
      # Trimming is only available for self-contained build, so force disable it here
      installFlags+=("-p:PublishTrimmed=false")
    fi
  fi

  if [[ -n ${dotnetUseAppHost-} ]]; then
    installFlags+=("-p:UseAppHost=true")
  fi

  if [[ -n ${enableParallelBuilding-} ]]; then
    local -r maxCpuFlag="$NIX_BUILD_CORES"
  else
    local -r maxCpuFlag="1"
  fi

  dotnetPublish() {
    local -r projectFile="${1-}"

    local useRuntime=
    _dotnetIsSolution "$projectFile" || useRuntime=1

    for runtimeId in "${runtimeIds[@]}"; do
      local runtimeIdFlags=()
      if [[ -n $useRuntime ]]; then
        runtimeIdFlags+=("--runtime" "$runtimeId")
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
             "${runtimeIdFlags[@]}" \
             "${flags[@]}" \
             "${installFlags[@]}"
    done
  }

  dotnetPack() {
    local -r projectFile="${1-}"

    local useRuntime=
    _dotnetIsSolution "$projectFile" || useRuntime=1

    for runtimeId in "${runtimeIds[@]}"; do
      local runtimeIdFlags=()
      if [[ -n $useRuntime ]]; then
        runtimeIdFlags+=("--runtime" "$runtimeId")
        # set RuntimeIdentifier because --runtime is broken:
        # https://github.com/dotnet/sdk/issues/13983
        runtimeIdFlags+=(-p:RuntimeIdentifier="$runtimeId")
      fi

      dotnet pack ${1+"$projectFile"} \
             -maxcpucount:"$maxCpuFlag" \
             -p:ContinuousIntegrationBuild=true \
             -p:Deterministic=true \
             -p:OverwriteReadOnlyFiles=true \
             --output "$out/share/nuget/source" \
             --configuration "$dotnetBuildType" \
             --no-restore \
             --no-build \
             "${runtimeIdFlags[@]}" \
             "${flags[@]}" \
             "${packFlags[@]}"
    done
  }

  if (( ${#projectFiles[@]} == 0 )); then
    dotnetPublish
  else
    local projectFile
    for projectFile in "${projectFiles[@]}"; do
      dotnetPublish "$projectFile"
    done
  fi

  if [[ -n ${packNupkg-} ]]; then
    if (( ${#projectFiles[@]} == 0 )); then
      dotnetPack
    else
      local projectFile
      for projectFile in "${projectFiles[@]}"; do
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
