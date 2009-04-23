source $stdenv/setup

preConfigure() {
    libc=$(cat ${NIX_GCC}/nix-support/orig-libc)
    echo "libc: $libc"

    case "${system}" in
	x86_64-*)	glibclibdir=lib64 ;;
	*)		glibclibdir=lib ;;
    esac

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
