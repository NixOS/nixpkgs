#! /bin/sh -e

. $stdenv/setup

header "downloading $out from $url"

curl "$url" > "$out"

actual=$(md5sum -b "$out" | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi

stopNest
