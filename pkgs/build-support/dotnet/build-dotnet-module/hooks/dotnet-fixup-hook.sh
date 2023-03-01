# Inherit arguments from the derivation
declare -a derivationMakeWrapperArgs="( ${makeWrapperArgs-} )"
makeWrapperArgs=( "${derivationMakeWrapperArgs[@]}" )

# First argument is the executable you want to wrap,
# the second is the destination for the wrapper.
wrapDotnetProgram() {
    if [ ! "${selfContainedBuild-}" ]; then
        local -r dotnetRootFlag=("--set" "DOTNET_ROOT" "@dotnetRuntime@")
    fi

    makeWrapper "$1" "$2" \
        --suffix "LD_LIBRARY_PATH" : "@runtimeDeps@" \
        "${dotnetRootFlag[@]}" \
        "${gappsWrapperArgs[@]}" \
        "${makeWrapperArgs[@]}"

    echo "installed wrapper to "$2""
}

dotnetFixupHook() {
    echo "Executing dotnetFixupPhase"

    if [ "${executables-}" ]; then
        for executable in ${executables[@]}; do
            path="$out/lib/$pname/$executable"

            if test -x "$path"; then
                wrapDotnetProgram "$path" "$out/bin/$(basename "$executable")"
            else
                echo "Specified binary \"$executable\" is either not an executable or does not exist!"
                echo "Looked in $path"
                exit 1
            fi
        done
    else
        while IFS= read -d '' executable; do
            wrapDotnetProgram "$executable" "$out/bin/$(basename "$executable")" \;
        done < <(find "$out/lib/$pname" ! -name "*.dll" -executable -type f -print0)
    fi

    echo "Finished dotnetFixupPhase"
}

if [[ -z "${dontDotnetFixup-}" ]]; then
    preFixupPhases+=" dotnetFixupHook"
fi
