#! /bin/sh

. $stdenv/setup

echo "downloading $url into $out..."

#prefetch=@prefix@/store/nix-prefetch-url-$md5
prefetch=/nix/store/nix-prefetch-url-$md5
if test -f "$prefetch"; then
    echo "using prefetched $prefetch";
    mv $prefetch $out || exit 1
else
    wget --passive-ftp "$url" -O "$out" || exit 1
fi

#actual=$(@bindir@/nix-hash --flat $out)
actual=$(/nix/bin/nix-hash --flat $out)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi
