. $stdenv/setup
. $makeWrapper

ensureDir $out/real

skip=143209

(dd bs=1 count=$skip of=/dev/null && dd) < $src | (cd $out/real && tar xvfj -)

rm -rf $out/real/Bin $out/real/postinst

glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
patchelf --interpreter $glibc/lib/ld-linux.so.* $out/real/realplay.bin

ensureDir $out/bin
makeWrapper "$out/real/realplay.bin" "$out/bin/realplay" \
    --set HELIX_LIBS "$out/real" \
    --suffix-each LD_LIBRARY_PATH ':' "$(addSuffix /lib $libPath)"

echo "$libstdcpp5/lib" > $out/real/mozilla/extra-library-path
echo "$out/bin" > $out/real/mozilla/extra-bin-path
