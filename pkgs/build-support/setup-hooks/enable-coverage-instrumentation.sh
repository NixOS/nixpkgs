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
