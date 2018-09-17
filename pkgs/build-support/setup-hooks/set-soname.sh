[[ -z "$noAbsoluteSoname" ]] && fixupOutputHooks+=(_doAbsoluteSoname)

_doAbsoluteSoname() {
    echo "Making sonames absolute"
    if test -d "$prefix" ; then
        find "$prefix" -type f '(' -name "lib*.so.*" -or -name 'lib*.so' ')' -not -name 'ld*' -exec patchelf --set-soname {} {} ';'
    fi
}
