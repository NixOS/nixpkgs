# shellcheck shell=bash
appsWrapperArgs=()

# Inherit arguments given in mkDerivation
appsWrapperArgs=( ${appsWrapperArgs-} )

makeAppWrapper() {
    local original="$1"
    local wrapper="$2"
    shift 2
    makeWrapper "$original" "$wrapper" "${appsWrapperArgs[@]}" "$@"
}

wrapApp() {
    local program="$1"
    shift 1
    wrapProgram "$program" "${appsWrapperArgs[@]}" "$@"
}

wrapAppsHook() {
    # skip this hook when requested
    [ -z "${dontWrapApps-}" ] || return 0

    # guard against running multiple times (e.g. due to propagation)
    [ -z "$wrapAppsHookHasRun" ] || return 0
    wrapAppsHookHasRun=1

    local targetDirs =( "$prefix/bin" "$prefix/sbin" "$prefix/libexec"  )
    echo "wrapping applications in ${targetDirs[@]}"

    for targetDir in "${targetDirs[@]}"
    do
        [ -d "$targetDir" ] || continue

        find "$targetDir" ! -type d -executable -print0 | while IFS= read -r -d '' file
        do
            # TODO: further checks
            # Following is done e.g. for Qt
            #
            # patchelf --print-interpreter "$file" >/dev/null 2>&1 || continue

            # Wrap executables
            if [ -f "$file" ]
            then
                echo "wrapping $file"
                wrapApp "$file"
            
            # Replace symbolic links with wrapper
            elif [ -h "$file" ]
            then
                target="$(readlink -e "$file")"
                echo "wrapping $file -> $target"
                rm "$file"
                makeAppWrapper "$target" "$file"
            fi
        done
    done

    # wrap links to binaries that point outside targetDirs
    # Note: links to binaries within targetDirs do not need
    #       to be wrapped as the binaries have already been wrapped
    if [[ ${#targetDirsThatExist[@]} -ne 0 ]]; then
        find "${targetDirsThatExist[@]}" -type l -xtype f -executable -print0 |
            while IFS= read -r -d '' linkPath; do
                linkPathReal=$(realpath "${linkPath}")
                for targetPath in "${targetDirsRealPath[@]}"; do
                    if [[ "$linkPathReal" == "$targetPath"* ]]; then
                        echo "Not wrapping link: '$linkPath' (already wrapped)"
                        continue 2
                    fi
                done
                echo "Wrapping link: '$linkPath'"
                wrapApp "${linkPath}"
            done
    fi

}

fixupOutputHooks+=(wrapQtAppsHook)
