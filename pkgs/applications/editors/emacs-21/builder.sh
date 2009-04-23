source $stdenv/setup

myglibc=`cat ${NIX_GCC}/nix-support/orig-libc`
echo "glibc: $myglibc" 

postConfigure() {
  cp $myglibc/lib/crt1.o src
  cp $myglibc/lib/crti.o src
  cp $myglibc/lib/crtn.o src
}

genericBuild
