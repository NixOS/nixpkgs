# shellcheck shell=bash
# This setup hook, for each output, moves everything in $output/lib64
# to $output/lib, and replaces $output/lib64 with a symlink to
# $output/lib. The rationale is that lib64 directories are unnecessary
# in Nix (since 32-bit and 64-bit builds of a package are in different
# store paths anyway).
# If the move would overwrite anything, it should fail on rmdir.

fixupOutputHooks+=(_moveLib64)

_moveLib64() {
    if [ "${dontMoveLib64-}" = 1 ]; then return; fi
    if [ ! -e "$prefix/lib64" -o -L "$prefix/lib64" ]; then return; fi
    echo "moving $prefix/lib64/* to $prefix/lib"
    mkdir -p $prefix/lib
    shopt -s dotglob
    for i in $prefix/lib64/*; do
        mv --no-clobber "$i" $prefix/lib
    done
    shopt -u dotglob
    rmdir $prefix/lib64
    ln -s lib $prefix/lib64
}
