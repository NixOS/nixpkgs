export NIX_SET_BUILD_ID=1
export NIX_LDFLAGS+=" --compress-debug-sections=zlib"
export NIX_CFLAGS_COMPILE+=" -ggdb -Wa,--compress-debug-sections"
dontStrip=1

fixupOutputHooks+=(_separateDebugInfo)

_separateDebugInfo() {
    local dst="${debug:-$out}"
    if [ "$prefix" = "$dst" ]; then return; fi

    dst="$dst/lib/debug/.build-id"

    # Find executables and dynamic libraries.
    local i magic
    while IFS= read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi

        # Extract the Build ID. FIXME: there's probably a cleaner way.
        local id="$(readelf -n "$i" | sed 's/.*Build ID: \([0-9a-f]*\).*/\1/; t; d')"
        if [ "${#id}" != 40 ]; then
            echo "could not find build ID of $i, skipping" >&2
            continue
        fi

        # Extract the debug info.
        header "separating debug info from $i (build ID $id)"
        mkdir -p "$dst/${id:0:2}"
        objcopy --only-keep-debug "$i" "$dst/${id:0:2}/${id:2}.debug"
        strip --strip-debug "$i"

        # Also a create a symlink <original-name>.debug.
        ln -sfn ".build-id/${id:0:2}/${id:2}.debug" "$dst/../$(basename "$i")"
    done < <(find "$prefix" -type f -print0)
}
