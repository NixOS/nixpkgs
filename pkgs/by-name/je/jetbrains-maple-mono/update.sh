#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
# Refreshes the version and every variant hash. Hashes are refreshed even when
# the tag is unchanged because upstream replaces release assets in place.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

repo="SpaceTimee/Fusion-JetBrainsMapleMono"
version="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" | jq -r .tag_name)"

sed -i "s/^  version = \".*\";/  version = \"${version}\";/" package.nix

hashes="{}"
for nf in NF XX; do
  for nr in NR XX; do
    for nl in NL XX; do
      for ht in HT XX; do
        variant="${nf}-${nr}-${nl}-${ht}"
        url="https://github.com/${repo}/releases/download/${version}/JetBrainsMapleMono-${variant}.zip"
        hash="$(nix-prefetch-url --type sha256 "${url}" | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256)"
        hashes="$(jq --arg k "${variant}" --arg v "${hash}" '. + {($k): $v}' <<< "${hashes}")"
      done
    done
  done
done

jq --sort-keys . <<< "${hashes}" > hashes.json
