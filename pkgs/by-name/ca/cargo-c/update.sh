#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils nix-update jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

latestVersion=`curl https://crates.io/api/v1/crates/cargo-c/versions | jq '.versions[0].num | split("+cargo-")'`
crateVersion=`jq -r '.[0]' <<< $latestVersion`
cargoVersion=`jq -r '.[1]' <<< $latestVersion`

sed -E -i "s/(cargoVersion = ).*;/\1\"$cargoVersion\";/" $SCRIPT_DIR/package.nix

nix-update cargo-c --version="$crateVersion"
