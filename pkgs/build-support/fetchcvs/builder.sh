source $stdenv/setup

header "exporting $url $module into $out"

prefetch=$(dirname $out)/cvs-checkout-tmp-$outputHash
echo $prefetch
if test -e "$prefetch"; then
    mv $prefetch $out
else
    if test -z "$tag"; then
      rtag="-DNOW"
    else
      rtag="-r $tag"
    fi
    cvs -f -d $url export $rtag -d $out $module
fi

actual=$(nix-hash $out)
if test "$actual" != "$outputHash"; then
    echo "hash is $actual, expected $outputHash" >&2
    exit 1
fi

stopNest
