# shellcheck shell=bash

fixupOutputHooks+=('if [ -z "${dontGenerateLDCache-}" ]; then generateLDCache "$prefix"; fi')

generateLDCache() {
    local dir="$1"
    [ -e "$dir" ] || return 0

    echo "generating LD cache for ELF executables in $dir"

    declare -a libDirs

    local i
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ .build-id ]]; then continue; fi
        if ! isELF "$i"; then continue; fi

        local lib
        while IFS= read -r lib; do
            lib="$(echo -n "$lib" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | cut -d ' ' -f 3)"
            if [ -n "$lib" ]; then
                echo "found lib: $lib"

                local dir="$(dirname "$lib")"

                if [[ ! " ${libDirs[*]} " =~ " $dir " ]]; then
                    libDirs+=("$dir")
                fi
            fi
        done < <(ldd "$i")
    done < <(find "$dir" -mindepth 2 -maxdepth 2 -type f -print0) # we only want $dir/x/y, not $dir/x/y/z or $dir/x

    (( ${#libDirs[@]} != 0 )) || return 0

    echo "found lib dirs: ${libDirs[*]}"

    mkdir -p "$out/etc"

    echo "$(IFS=$'\n'; echo "${libDirs[*]}")" > "$TMPDIR/ld.so.conf"

    ldconfig -f "$TMPDIR/ld.so.conf" -C "$out/etc/ld.so.cache" || echo "failed to generate LD cache"
}
