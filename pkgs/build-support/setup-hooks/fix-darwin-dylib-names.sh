# On macOS, binaries refer to dynamic library dependencies using
# either relative paths (e.g. "libicudata.dylib", searched relative to
# $DYLD_LIBRARY_PATH) or absolute paths
# (e.g. "/nix/store/.../lib/libicudata.dylib").  In Nix, the latter is
# preferred since it allows programs to just work.  When linking
# against a library (e.g. "-licudata"), the linker uses the install
# name embedded in the dylib (which can be shown using "otool -D").
# Most packages create dylibs with absolute install names, but some do
# not.  This setup hook fixes dylibs by setting their install names to
# their absolute path (using "install_name_tool -id").  It also
# rewrites references in other dylibs to absolute paths.

fixupOutputHooks+=('fixDarwinDylibNamesIn $prefix')

fixDarwinDylibNames() {
    local flags=()
    local old_id

    for fn in "$@"; do
        flags+=(-change "$(basename "$fn")" "$fn")
    done

    for fn in "$@"; do
        if [ -L "$fn" ]; then continue; fi
        echo "$fn: fixing dylib"
        int_out=$(@targetPrefix@install_name_tool -id "$fn" "${flags[@]}" "$fn" 2>&1)
        result=$?
        if [ "$result" -ne 0 ] &&
            ! grep "shared library stub file and can't be changed" <<< "$out"
        then
            echo "$int_out" >&2
            exit "$result"
        fi
    done
}

fixDarwinDylibNamesIn() {
    local dir="$1"
    fixDarwinDylibNames $(find "$dir" -name "*.dylib" -o -name "*.so" -o -name "*.so.*")
}
