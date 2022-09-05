# Inherit arguments from the derivation
makeWrapperArgs=( ${makeWrapperArgs-} )

# First argument is the executable you want to wrap,
# the second is the destination for the wrapper.
wrapDotnetProgram() {
    if [ ! "${selfContainedBuild-}" ]; then
        dotnetRootFlag=("--set" "DOTNET_ROOT" "@dotnetRuntime@")
    fi

    makeWrapper "$1" "$2" \
        "${dotnetRootFlag[@]}" \
        --suffix "LD_LIBRARY_PATH" : "@runtimeDeps@" \
        "${gappsWrapperArgs[@]}" \
        "${makeWrapperArgs[@]}"

    echo "Installed wrapper to: "$2""
}

dotnetFixupHook() {
    echo "Executing dotnetFixupPhase"

    if [ "${executables}" ]; then
        for executable in ${executables[@]}; do
            execPath="$out/lib/${pname}/$executable"

            if [[ -f "$execPath" && -x "$execPath" ]]; then
                wrapDotnetProgram "$execPath" "$out/bin/$(basename "$executable")"
            else
                echo "Specified binary \"$executable\" is either not an executable, or does not exist!"
                exit 1
            fi
        done
    else
        for executable in $out/lib/${pname}/*; do
            if [[ -f "$executable" && -x "$executable" && "$executable" != *"dll"* ]]; then
                wrapDotnetProgram "$executable" "$out/bin/$(basename "$executable")"
            fi
        done
    fi

    echo "Finished dotnetFixupPhase"
}

if [[ -z "${dontDotnetFixup-}" ]]; then
    preFixupPhases+=" dotnetFixupHook"
fi
