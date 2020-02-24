#!/usr/bin/env bash

URL_amd64=$(curl -s https://anydesk.com/en/downloads/linux | grep "https://[a-z0-9._/-]*_amd64.deb" -o | uniq)
URL_i386=$(curl -s https://anydesk.com/en/downloads/linux | grep "https://[a-z0-9._/-]*_i386.deb" -o | uniq)

HASH_amd64=$(nix-prefetch-url "$URL_amd64")
HASH_i386=$(nix-prefetch-url "$URL_i386")

VERSION=$(echo "$URL_amd64" | grep "[0-9]*\.[0-9]*\.[0-9]*" -o)

sed "s|x86_64-linux *= .*|x86_64-linux = \"$HASH_amd64\";|" -i default.nix
sed "s|i386-linux *= .*|i386-linux   = \"$HASH_amd64\";|" -i default.nix
sed "s|version = .*|version = \"$VERSION\";|" -i default.nix
