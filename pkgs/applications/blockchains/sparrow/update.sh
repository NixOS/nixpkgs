#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq gnused gnupg common-updater-scripts

set -eu -o pipefail

version="$(curl -s https://api.github.com/repos/sparrowwallet/sparrow/releases| jq '.[] | {name} | limit(1;.[])' | sed 's/[\"v]//g' | head -n 1)"
depname="sparrow-$version-x86_64.tar.gz"
src_root="https://github.com/sparrowwallet/sparrow/releases/download/$version";
src="$src_root/$depname";
manifest="$src_root/sparrow-$version-manifest.txt"
signature="$src_root/sparrow-$version-manifest.txt.asc"
key="D4D0 D320 2FC0 6849 A257 B38D E946 1833 4C67 4B40"

pushd $(mktemp -d --suffix=-sparrow-updater)
export GNUPGHOME=$PWD/gnupg
mkdir -m 700 -p "$GNUPGHOME"
curl -L -o "$depname" -- "$src"
curl -L -o manifest.txt -- "$manifest"
curl -L -o signature.asc -- "$signature"
gpg --batch --recv-keys "$key"
gpg --batch --verify signature.asc manifest.txt
sha256sum -c --ignore-missing manifest.txt
sha256=$(nix-prefetch-url --type sha256 "file://$PWD/$depname")
popd

update-source-version sparrow-unwrapped "$version" "$sha256"
