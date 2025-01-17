#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gnused prefetch-yarn-deps

set -e

# update src version and hash
version="$(list-git-tags | sort -V | tail -1 | sed 's|server-||')"

update-source-version awk-language-server "$version"

# update vendored yarn.lock & package.json
newSrc="$(nix-build --no-out-link -A awk-language-server.src)"

nixFile="$(nix-instantiate --eval --strict -A 'awk-language-server.meta.position' \
    | sed -re 's/^"(.*):[0-9]+"$/\1/')"

nixFileDir="$(dirname "$nixFile")"

cp --force --no-preserve=mode "$newSrc"/{yarn.lock,package.json} "$nixFileDir/"

# update offlineCache hash
oldCacheSriHash="$(nix-instantiate --eval --strict \
    -A 'awk-language-server.offlineCache.drvAttrs.outputHash')"

newCacheHash="$(prefetch-yarn-deps "$nixFileDir/yarn.lock")"

newCacheSriHash="$(nix-hash --to-sri --type sha256 "$newCacheHash")"

sed -i "s|$oldCacheSriHash|\"$newCacheSriHash\"|" "$nixFile"

