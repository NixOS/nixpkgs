source $stdenv/setup

ensureDir "$out/lib/bmp/Input"
installFlags="install libdir=$out/lib/bmp/Input"

genericBuild
