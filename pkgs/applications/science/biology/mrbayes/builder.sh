# builder for mrbayes - note: only builds on Unix

source $stdenv/setup

tar xvfz $src
cd mrbayes-*
make
mkdir -p $out/bin
cp -v mb $out/bin
