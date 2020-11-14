set -e

source $stdenv/setup

tar xzvf $src
mkdir $out
mv batik-* $out/batik
