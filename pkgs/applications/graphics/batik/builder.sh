set -e

. $stdenv/setup

unzip $src
mkdir $out
mv batik-* $out/batik
