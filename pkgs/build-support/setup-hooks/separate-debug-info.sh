export NIX_SET_BUILD_ID=1
export NIX_LDFLAGS+=" --compress-debug-sections=zlib"
export NIX_CFLAGS_COMPILE+=" -ggdb -Wa,--compress-debug-sections"
export NIX_RUSTFLAGS+=" -g -C strip=none"

cksumAlgo=sha256

fixupOutputHooks+=(_separateDebugInfo)
postUnpackHooks+=(_recordPristineSourceHashes)

_recordPristineSourceHashes() {
    # shellcheck disable=2154
    [ -e "$sourceRoot" ] || return 0

    local checksumFileName=__nix_source_checksums
    echo "separate-debug-info: recording checksum of source files for debug support..."
    find "$sourceRoot" -type f -exec cksum -a "$cksumAlgo" '{}' \+ > "$checksumFileName"
    recordedSourceChecksumsFileName="$(readlink -f "$checksumFileName")"
}

_separateDebugInfo() {
    # shellcheck disable=2154
    [ -e "$prefix" ] || return 0

    local debugOutput="${debug:-$out}"
    if [ "$prefix" = "$debugOutput" ]; then return 0; fi

    # in case there is nothing to strip, don't fail the build
    mkdir -p "$debugOutput"

    local dst="$debugOutput/lib/debug/.build-id"

    local source
    local sourceOverlay
    # shellcheck disable=2154
    if [ -e "$src" ]; then
        source="$src"
        if [ -n "${recordedSourceChecksumsFileName:-}" ]; then
            sourceOverlay="$debugOutput/src/overlay"
        else
            sourceOverlay=""
        fi
    else
        source=""
        sourceOverlay=""
    fi

    # Find executables and dynamic libraries.
    local i
    while IFS= read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi

        [ -z "${READELF:-}" ] && echo "_separateDebugInfo: '\$READELF' variable is empty, skipping." 1>&2 && break
        [ -z "${OBJCOPY:-}" ] && echo "_separateDebugInfo: '\$OBJCOPY' variable is empty, skipping." 1>&2 && break

        # Extract the Build ID. FIXME: there's probably a cleaner way.
        local id
        id="$($READELF -n "$i" | sed 's/.*Build ID: \([0-9a-f]*\).*/\1/; t; d')"
        if [ "${#id}" != 40 ]; then
            echo "could not find build ID of $i, skipping" >&2
            continue
        fi


        # Extract the debug info.
        echo "separating debug info from $i (build ID $id)"

        local debuginfoDir="$dst/${id:0:2}"
        local buildIdPrefix="$debuginfoDir/${id:2}"
        local debuginfoFile="$buildIdPrefix.debug"
        local executableSymlink="$buildIdPrefix.executable"
        local sourceSymlink="$buildIdPrefix.source"
        local sourceOverlaySymlink="$buildIdPrefix.sourceoverlay"

        mkdir -p "$debuginfoDir"

        if [ -f "$debuginfoFile" ]; then
            echo "separate-debug-info: warning: multiple files with build id $id found, overwriting"
        fi

        # This may fail, e.g. if the binary is for a different
        # architecture than we're building for.  (This happens with
        # firmware blobs in QEMU.)
        if $OBJCOPY --only-keep-debug "$i" "$debuginfoFile"; then
            # If we succeeded, also a create a symlink <original-name>.debug.
            ln -sfn "$debuginfoFile" "$dst/../$(basename "$i")"
            # also create a symlink mapping the build-id to the original elf file and the source
            # debuginfod protocol relies on it
            ln -sfn "$i" "$executableSymlink"
            if [ -n "$source" ]; then
                ln -sfn "$source" "$sourceSymlink"
            fi
            if [ -n "$sourceOverlay" ]; then
                # create it lazily
                if [ ! -d "$sourceOverlay" ]; then
                    echo "separate-debug-info: copying patched source files to $sourceOverlay..."
                    mkdir -p "$sourceOverlay"
                    pushd "$(dirname "$recordedSourceChecksumsFileName")" || { echo "separate-debug-info: failed to cd parent directory of $recordedSourceChecksumsFileName"; return 1; }
                    while IFS= read -r -d $'\0'  modifiedSourceFile; do
                        if [ -z "$modifiedSourceFile" ]; then
                            continue
                        fi
                        # this can happen with files with '\n' in their name
                        if [ ! -f "$modifiedSourceFile" ]; then
                            echo "separate-debug-info: cannot save modified source file $modifiedSourceFile: does not exist. ignoring"
                            continue
                        fi
                        mkdir -p "$sourceOverlay/$(dirname "$modifiedSourceFile")"
                        cp -v "$modifiedSourceFile" "$sourceOverlay/$modifiedSourceFile"
                    done < <(LANG=C cksum -a "$cksumAlgo" --check --ignore-missing --quiet "$recordedSourceChecksumsFileName" 2>&1 | sed -n -e 's/: FAILED$/\x00/p' | sed -z -e 's/^\n//')
                    popd || { echo "separate-debug-info: failed to popd" ; return 1; }
                fi
                ln -sfn "$sourceOverlay" "$sourceOverlaySymlink"
            fi
        else
            # If we failed, try to clean up unnecessary directories
            rmdir -p "$dst/${id:0:2}" --ignore-fail-on-non-empty
        fi
    done < <(find "$prefix" -type f -print0 | sort -z)
}
