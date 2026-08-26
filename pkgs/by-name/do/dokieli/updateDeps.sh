#!usr/bin/env bash

export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-dokieli}"

oldversion="${UPDATE_NIX_OLD_VERSION-}"
newversion="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.version" | cut -d'"' -f2)"

if [ "$oldversion" == "$newversion" ]; then
  echo "No new version."
  exit 0
fi

workdir="$(mktemp -d)"

# File to replace stuff in
fname="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" $UPDATE_NIX_ATTR_PATH).file" | cut -d'"' -f2)"

oldhash="$(nix-instantiate . --eval --strict -A "$UPDATE_NIX_ATTR_PATH.offlineCache.outputHash" | cut -d'"' -f2)"

newsource="$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)"

yarn-berry-fetcher missing-hashes "$newsource"/yarn.lock > "$workdir"/missing-hashes.json
newhash="$(yarn-berry-fetcher prefetch "$newsource"/yarn.lock "$workdir"/missing-hashes.json)"

sed -i "$fname" \
  -e "s|$oldhash|$newhash|g"

mv "$workdir"/missing-hashes.json "$(dirname "$fname")"/missing-hashes.json
