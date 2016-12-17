source $stdenv/setup

unpackPhase

cd freebayes-*

make

mkdir -p $out/bin
cp bin/freebayes bin/bamleftalign $out/bin
cp scripts/* $out/bin
