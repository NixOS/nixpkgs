export NIX_LDFLAGS+=" --build-id"
export NIX_CFLAGS_COMPILE+=" -ggdb"
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
        objcopy --only-keep-debug "$i" "$dst/${id:0:2}/${id:2}.debug" --compress-debug-sections
        strip --strip-debug "$i"

        # Also a create a symlink <original-name>.debug.
        ln -sfn ".build-id/${id:0:2}/${id:2}.debug" "$dst/../$(basename "$i")"
    done < <(find "$prefix" -type f -print0)
}

# - We might prefer to compress the debug info during link-time already,
#   but our ld doesn't support --compress-debug-sections=zlib (yet).
# - Debug info may cause problems due to excessive memory usage during linking.
#   Using -Wa,--compress-debug-sections should help with that;
#   further interesting information: https://gcc.gnu.org/wiki/DebugFission
# - Another related tool: https://fedoraproject.org/wiki/Features/DwarfCompressor

