. $stdenv/setup

header "exporting $url (r$rev) into $out"

prefetch=$(dirname $out)/svn-checkout-tmp-$md5
echo $prefetch
if test -e "$prefetch"; then
    mv $prefetch $out
else
    svn export -r "$rev" "$url" $out
fi

actual=$(nix-hash $out)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5" >&2
    exit 1
fi

stopNest
