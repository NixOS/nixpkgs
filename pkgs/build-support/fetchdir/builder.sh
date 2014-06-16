source $stdenv/setup

echo "copying $pathname into $out..."

cp -r "$pathname" "$out" || exit 1

actual=$(nix-hash --type md5 $out | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi
