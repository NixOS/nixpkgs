postPhases+=" cleanupBuildDir"

# Force GCC to build with coverage instrumentation.  Also disable
# optimisation, since it may confuse things.
export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -O0 --coverage"

# FIXME: Handle the case where postUnpack is already set.
postUnpack() {
    # This is an uberhack to prevent libtool from remoaving gcno
    # files.  This has been fixed in libtool, but there are packages
    # out there with old ltmain.sh scripts.  See
    # http://www.mail-archive.com/libtool@gnu.org/msg10725.html
    for i in $(find -name ltmain.sh); do
        substituteInPlace $i --replace '*.$objext)' '*.$objext | *.gcno)'
    done
}

# Get rid of everything that isn't a gcno file or a C source file.
# Also strip the `.tmp_' prefix from gcno files.  (The Linux kernel
# creates these.)
cleanupBuildDir() {
    if ! [ -e $out/.build ]; then return; fi

    find $out/.build/ -type f -a ! \
        \( -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hh" -o -name "*.y" -o -name "*.l" -o -name "*.gcno" \) \
        | xargs rm -f --

    for i in $(find $out/.build/ -name ".tmp_*.gcno"); do
        mv "$i" "$(echo $i | sed s/.tmp_//)"
    done
}
