#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cargo curl jq

set -euo pipefail

crate=hacksaw
pkgPath="$(dirname "$0")"

# update source
url="https://crates.io/api/v1/crates/$crate"
version="$(curl -s "$url" | jq -r .crate.max_stable_version)"
prefetch="$(nix-prefetch-url --print-path --type sha256 --unpack "$url/$version/download")"
cat >"$pkgPath/source.json" <<EOF
{
  "pname": "$crate",
  "version": "$version",
  "hash": "$(nix hash to-sri --type sha256 "$(printf '%s' "$prefetch" | head -n1)")"
}
EOF

# update lockfile
tmp="$(mktemp -d)"
trap 'rm -rf $tmp' EXIT
cp -r "$(printf '%s' "$prefetch" | tail -n1)/"* "$tmp"
chmod -R +w "$tmp"
cargo update --manifest-path "$tmp/Cargo.toml"
cp "$tmp/Cargo.lock" "$pkgPath/Cargo.lock"
