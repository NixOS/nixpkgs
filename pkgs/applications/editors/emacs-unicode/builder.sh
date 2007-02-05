source $stdenv/setup

myglibc=`cat ${NIX_GCC}/nix-support/orig-libc`
echo "glibc: $myglibc" 

postConfigure=postConfigure
postConfigure() {
  cp $myglibc/lib/crt1.o src
  cp $myglibc/lib/crti.o src
  cp $myglibc/lib/crtn.o src

  for i in Makefile ./src/Makefile ./lib-src/Makefile ./leim/Makefile ./admin/unidata/Makefile; do
      substituteInPlace $i --replace /bin/pwd pwd
  done
}

genericBuild
