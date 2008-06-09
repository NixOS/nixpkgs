source $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    libc=$(cat ${NIX_GCC}/nix-support/orig-libc)
    echo "libc: $libc"

    for i in src/s/*.h src/m/*.h; do
        substituteInPlace $i \
            --replace /usr/lib/crt1.o $libc/lib/crt1.o \
            --replace /usr/lib/crti.o $libc/lib/crti.o \
            --replace /usr/lib/crtn.o $libc/lib/crtn.o
    done
    
    for i in Makefile.in ./src/Makefile.in ./lib-src/Makefile.in ./leim/Makefile.in ./admin/unidata/Makefile; do
        substituteInPlace $i --replace /bin/pwd pwd
    done
}

preBuild="make bootstrap"

genericBuild
