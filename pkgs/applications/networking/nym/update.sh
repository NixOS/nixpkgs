#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch
# shellcheck shell=bash

# adapted from rust-analyzer

set -euo pipefail
cd "$(dirname "$0")"
nixpkgs=../../../..

owner=$(sed -nE 's/.*\bowner = "(.*)".*/\1/p' ./default.nix)
repo=$(sed -nE 's/.*\brepo = "(.*)".*/\1/p' ./default.nix)
rev=$(
    curl -s "https://api.github.com/repos/$owner/$repo/releases" |
    jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output
)
version=${rev:1}
old_version=$(sed -nE 's/.*\bversion = "(.*)".*/\1/p' ./default.nix)
if grep -q 'cargoSha256 = ""' ./default.nix; then
    old_version='broken'
fi
if [[ "$version" == "$old_version" ]]; then
    echo "Up to date: $version"
    exit
fi
echo "$old_version -> $version"

sha256=$(nix-prefetch -f "$nixpkgs" nym.src --rev "$rev")
# Clear cargoSha256 to avoid inconsistency.
sed -e "s/version = \".*\"/version = \"$version\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"$sha256\"/" \
    -e "s/cargoSha256 = \".*\"/cargoSha256 = \"\"/" \
    --in-place ./default.nix

echo "Prebuilding for cargoSha256"
cargo_sha256=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).nym.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed "s/cargoSha256 = \".*\"/cargoSha256 = \"$cargo_sha256\"/" \
    --in-place ./default.nix
