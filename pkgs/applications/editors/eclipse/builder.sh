set -e

. $stdenv/setup

$unzip/bin/unzip $src 
mkdir $out
mv eclipse $out/
