. $stdenv/setup

header "downloading $out from $url"

curl --fail --location --max-redirs 20 "$url" > "$out"

if test "$NIX_OUTPUT_CHECKED" != "1"; then
    actual=$(md5sum -b "$out" | cut -c1-32)
    if test "$actual" != "$md5"; then
        echo "hash is $actual, expected $md5"
        exit 1
    fi
fi

stopNest
