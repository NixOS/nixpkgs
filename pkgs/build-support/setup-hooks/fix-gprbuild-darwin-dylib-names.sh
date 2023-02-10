#shellcheck shell=bash

# On macOS, binaries refer to dynamic library dependencies using
# either:
# - paths relative to those in specific environment variables (e.g.
#   "libicudata.dylib", searched relative to $DYLD_LIBRARY_PATH and
#   $DYLD_FALLBACK_LIBRARY_PATH);
# - paths relative to dynamic locations that are denoted by special tokens
#   (e.g. "@rpath/libicudata.dylib"); or
# - absolute paths (e.g. "/nix/store/.../lib/libicudata.dylib").
# (See the dyld(1) man page for an overview.)
#
# In Nix, the latter is preferred since it allows programs to just work.  When
# linking against a library (e.g. "-licudata"), the linker uses the install name
# embedded in the dylib (which can be shown using "otool -D").  Most packages
# create dylibs with absolute install names, but some do not.  This setup hook
# fixes dylibs by setting their install names to their absolute path (using
# "install_name_tool -id").  It also rewrites references in other dylibs to
# absolute paths.

#shellcheck disable=SC2016
fixupOutputHooks+=('fixGPRBuildDarwinDylibNamesIn $prefix')

fixGPRBuildDarwinDylibNamesIn() {
    if (( $# == 0 )); then
        echo "Error: no directory specified" >&2
        exit 1
    fi

    local dir="$1"

    # The `mapfile -t -d '' array_name < {file_with_NUL_delimiters}` pattern
    # avoids pitfalls with unsafe characters in file names, and works for bash
    # 4.4+; see e.g. https://mywiki.wooledge.org/BashProgramming/03 (Working
    # with files)
    #
    # While we only want to change Mach-O executables and dylibs, the dylib
    # dependencies in them may be to symlinks to the target dylib, so we must
    # catch those too.
    mapfile -t -d '' candidates < <( \
        find -P "$dir" \( \
                -executable -type f \
                -o \
                -name "*.dylib" \
            \) -print0
    )

    local -a executables dylibRefs dylibs
    for c in "${candidates[@]}"; do
        if [[ "$c" =~ .dylib$ ]]; then
            dylibRefs+=("$c")
        fi

        res="$(file --no-dereference "$c")"
        if [[ "$res" =~ Mach-O.*executable ]]; then
            executables+=("$c")
        # There may be Mach-O shared library stubs or fixed virtual memory
        # shared libraries; we can't change those
        elif [[ "$res" =~ Mach-O.*linked\ shared\ library &&
                ! "$res" =~ stub ]]; then
            dylibs+=("$c")
        fi
    done

    local flags=()
    for dylibRef in "${dylibRefs[@]}"; do
        flags+=(-change "@rpath/${dylibRef##*/}" "$dylibRef")
    done

    for exe in "${executables[@]}"; do
        echo "$exe: fixing executable"
        fixGPRBuildDarwinDylibNames "$exe" "${flags[@]}"
    done

    for dylib in "${dylibs[@]}"; do
        echo "$dylib: fixing dylib"
        fixGPRBuildDarwinDylibNames "$dylib" "${flags[@]}"
    done
}

# First positional parameter is the file to change; remaining positional
# parameters are the dylib dependencies to rewrite
fixGPRBuildDarwinDylibNames() {
    f="$1"
    shift
    int_out=$(@targetPrefix@install_name_tool -id "$f" "$@" "$f" 2>&1)
    result=$?
    if (( "$result" != 0 )); then
        echo "$int_out" >&2
        exit "$result"
    fi
}

fixGPRBuildDarwinDylibNamesIn "$@"
