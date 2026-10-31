# shellcheck shell=bash
# This setup hook, for each output, moves everything in $output/sbin
# to $output/bin, and replaces $output/sbin with a symlink to
# $output/bin.

fixupOutputHooks+=(_moveSbin)

_moveSbin() {
    if [ "${dontMoveSbin-}" = 1 ]; then return; fi
    if [ ! -e "$prefix/sbin" -o -L "$prefix/sbin" ]; then return; fi
    echo "moving $prefix/sbin/* to $prefix/bin"
    mkdir -p $prefix/bin
    shopt -s dotglob
    for i in $prefix/sbin/*; do
        mv "$i" $prefix/bin
    done
    shopt -u dotglob
    rmdir $prefix/sbin
    ln -s bin $prefix/sbin
}
