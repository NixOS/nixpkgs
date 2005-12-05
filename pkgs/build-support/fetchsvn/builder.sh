source $stdenv/setup

header "exporting $url (r$rev) into $out"

prefetch=$(dirname $out)/svn-checkout-tmp-$outputHash
echo $prefetch
if test -e "$prefetch"; then
    mv $prefetch $out
else
    svn export -r "$rev" "$url" $out
fi

actual=$(nix-hash $out)
if test "$actual" != "$outputHash"; then
    echo "hash is $actual, expected $outputHash" >&2
    exit 1
fi

stopNest
