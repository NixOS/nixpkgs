# shellcheck shell=bash

fixupOutputHooks+=('if [ -z "${dontGenerateLDCache-}" ]; then generateLDCache "$prefix"; fi')

generateLDCache() {
    local dir="$1"
    [ -e "$dir" ] || return 0

    echo "generating LD cache for ELF executables in $dir"

    local i
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ .build-id ]]; then continue; fi
        if ! isELF "$i"; then continue; fi
        echo "ld-caching $i"
        patchelf --build-resolution-cache "$i" || true
    done < <(find "$dir" -type f -print0)
}
