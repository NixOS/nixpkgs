set -e

. $stdenv/setup

tar zxvf $src 
mkdir $out
mv eclipse $out/
