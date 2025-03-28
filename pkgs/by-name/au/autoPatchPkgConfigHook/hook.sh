fixupOutputHooks+=(autoPatchPcHook)

autoPatchPcHook() (
    # Where the pkg-config files are
    local -r devOut="${!outputDev}"

    # Some packages list their own libraries as deps, they should be searched first in case of cyclic deps
    local -r PKG_CONFIG_PATH_@suffixSalt@="$devOut/lib/pkgconfig:$devOut/share/pkgconfig:$devOut/lib64/pkgconfig:$PKG_CONFIG_PATH_@suffixSalt@"
    export PKG_CONFIG_PATH_@suffixSalt@

    shopt -s nullglob
    for pc in "$devOut/"{lib,lib64,share}/pkgconfig/*.pc; do
        echo "Fixing Require paths in '$pc'"

        if ! python3 "@PATCH_PC_SCRIPT@" "$pc" > "$pc.patched"; then
            cat "$pc.patched"
            echo "Fixing pkg-config paths failed! Are all required dependcies in build closure?"
            exit 1
        fi
        mv -fT -- "$pc.patched" "$pc"
    done
)

