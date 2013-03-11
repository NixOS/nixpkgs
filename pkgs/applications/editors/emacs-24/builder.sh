source $stdenv/setup

# This hook is supposed to be run on Linux. It patches the proper locations of
# the crt{1,i,n}.o files into the build to ensure that Emacs is linked with
# *our* versions, not the ones found in the system, as it would do by default.
# On other platforms, this appears to be unnecessary.
preConfigure() {
    case "${system}" in
	x86_64-linux)	glibclibdir=lib64 ;;
	i686-linux)	glibclibdir=lib ;;
        *)              return;
    esac

    libc=$(cat ${NIX_GCC}/nix-support/orig-libc)
    echo "libc: $libc"

    for i in src/s/*.h src/m/*.h; do
        substituteInPlace $i \
            --replace /usr/${glibclibdir}/crt1.o $libc/${glibclibdir}/crt1.o \
            --replace /usr/${glibclibdir}/crti.o $libc/${glibclibdir}/crti.o \
            --replace /usr/${glibclibdir}/crtn.o $libc/${glibclibdir}/crtn.o \
            --replace /usr/lib/crt1.o $libc/${glibclibdir}/crt1.o \
            --replace /usr/lib/crti.o $libc/${glibclibdir}/crti.o \
            --replace /usr/lib/crtn.o $libc/${glibclibdir}/crtn.o
    done

    for i in Makefile.in ./src/Makefile.in ./lib-src/Makefile.in ./leim/Makefile.in; do
        substituteInPlace $i --replace /bin/pwd pwd
    done
}

genericBuild
