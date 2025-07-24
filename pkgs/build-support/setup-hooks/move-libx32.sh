# This setup hook is like _moveLib64 but it's for libx32

fixupOutputHooks+=(_moveLibx32)

_moveLibx32() {
    if [ "${dontMoveLibx32-}" = 1 ]; then return; fi
    if [ ! -e "$prefix/libx32" -o -L "$prefix/libx32" ]; then return; fi
    echo "moving $prefix/libx32/* to $prefix/lib"
    mkdir -p $prefix/lib
    shopt -s dotglob
    for i in $prefix/libx32/*; do
        mv --no-clobber "$i" $prefix/lib
    done
    shopt -u dotglob
    rmdir $prefix/libx32
    ln -s lib $prefix/libx32
}
