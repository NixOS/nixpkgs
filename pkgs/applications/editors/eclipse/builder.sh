source $stdenv/setup
source $makeWrapper

unpackFile $src 
ensureDir $out
mv eclipse $out/

makeWrapper $out/eclipse/eclipse $out/bin/eclipse
