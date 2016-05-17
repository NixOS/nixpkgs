export NIX_SET_BUILD_ID=1
export NIX_CFLAGS_COMPILE+=' -ggdb'
dontStrip=1

fixupOutputHooks+=(_separateDebugInfo)

_separateDebugInfo() {
    local debugout="${debug:-$out}"
    if [ "$prefix" = "$debugout" ]; then return; fi

    local hashandname="$(basename "$debugout")"
    local debugpath="$(dirname "$debugout")/${hashandname:0:2} ${hashandname:2}"

    # Find executables and dynamic libraries.
    local i magic
    while read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi

        # Extract the Build ID. FIXME: there's probably a cleaner way.
        local id="$(readelf -n "$i" | sed 's/.*Build ID: \([0-9a-f]*\).*/\1/; t; d')"
        if [ "${#id}" != 40 ]; then
            echo "could not find build ID of $i, skipping" >&2
            continue
        fi

        # Extract the debug info.
        header "separating debug info from $i (build ID $id)"
        local relpath="lib/debug/.build-id/${id:0:2}/${id:2}.debug"
        local debugfile="$debugout/$relpath"
        mkdir -p $(dirname "$debugfile")
        objcopy --only-keep-debug --compress-debug-sections "$i" "$debugfile"
        # Also a create a symlink <original-name>.debug.
        ln -sfn ".build-id/${id:0:2}/${id:2}.debug" "$debugout/lib/debug/$(basename "$i").debug"

        if ! objdump -sj .nix_debug "$i" &> /dev/null; then
            # The space is to prevent a reference.
            objcopy --add-section=.nix_debug=<(echo "$debugpath/$relpath") "$i"
        fi
        strip $commonStripFlags "$i"

    done < <(find "$prefix" -type f -print0)
}
