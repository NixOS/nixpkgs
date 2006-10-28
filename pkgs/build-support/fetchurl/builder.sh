source $stdenv/setup

header "downloading $out from $url"

curl --fail --location --max-redirs 20 --disable-epsv "$url" > "$out"

if test "$NIX_OUTPUT_CHECKED" != "1"; then
    if test "$outputHashAlgo" != "md5"; then
        echo "hashes other than md5 are unsupported in Nix <= 0.7, upgrade to Nix 0.8"
        exit 1
    fi
    actual=$(md5sum -b "$out" | cut -c1-32)
    if test "$actual" != "$id"; then
        echo "hash is $actual, expected $id"
        exit 1
    fi
fi

stopNest
