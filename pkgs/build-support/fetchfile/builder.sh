source $stdenv/setup

echo "copying $url into $out..."

cp "$pathname" "$out" || exit 1

actual=$(md5sum -b $out | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi
