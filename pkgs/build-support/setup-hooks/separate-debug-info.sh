export NIX_SET_BUILD_ID=1
export NIX_LDFLAGS+=" --compress-debug-sections=zlib"
export NIX_CFLAGS_COMPILE+=" -ggdb -Wa,--compress-debug-sections"
export RUSTFLAGS+=" -g"

fixupOutputHooks+=(_separateDebugInfo)

_separateDebugInfo() {
    [ -e "$prefix" ] || return 0

    local dst="${debug:-$out}"
    if [ "$prefix" = "$dst" ]; then return 0; fi

    # in case there is nothing to strip, don't fail the build
    mkdir -p "$dst"

    dst="$dst/lib/debug/.build-id"

    # Find executables and dynamic libraries.
    local i
    while IFS= read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi

        # Extract the Build ID. FIXME: there's probably a cleaner way.
        local id="$($READELF -n "$i" | sed 's/.*Build ID: \([0-9a-f]*\).*/\1/; t; d')"
        if [ "${#id}" != 40 ]; then
            echo "could not find build ID of $i, skipping" >&2
            continue
        fi

        # Extract the debug info.
        echo "separating debug info from $i (build ID $id)"
        mkdir -p "$dst/${id:0:2}"

        # This may fail, e.g. if the binary is for a different
        # architecture than we're building for.  (This happens with
        # firmware blobs in QEMU.)
        (
            if [ -f "$dst/${id:0:2}/${id:2}.debug" ]
            then
                echo "separate-debug-info: warning: multiple files with build id $id found, overwriting"
            fi
            $OBJCOPY --only-keep-debug "$i" "$dst/${id:0:2}/${id:2}.debug"

            # Also a create a symlink <original-name>.debug.
            ln -sfn ".build-id/${id:0:2}/${id:2}.debug" "$dst/../$(basename "$i")"
        ) || rmdir -p "$dst/${id:0:2}"
    done < <(find "$prefix" -type f -print0 | sort -z)
}
