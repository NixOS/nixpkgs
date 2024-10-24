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
            dotnetRootFlagsArray+=("--set-default" "DOTNET_ROOT" "$dotnetRuntime")
            dotnetRootFlagsArray+=("--suffix" "PATH" ":" "$dotnetRuntime/bin")
        else
            dotnetRootFlagsArray+=("--set" "DOTNET_ROOT" "$dotnetRuntime")
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

dotnetFixupHook() {
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
    preFixupPhases+=" dotnetFixupHook"
fi
