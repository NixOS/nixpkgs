#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash cacert cargo coreutils curl diffutils git gnused jq nix nix-update yarn-berry_4.yarn-berry-fetcher
# shellcheck shell=bash

set -euo pipefail

pkgDir=$(dirname "$(readlink -f "$0")")
nixpkgs=$(readlink -f "$pkgDir/../../../..")
attr=eigenwallet

version=${1:-$(curl -sfL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
  https://api.github.com/repos/eigenwallet/core/releases/latest | jq -r .tag_name)}

cd "$nixpkgs"

nix-update "$attr" --version "$version" --src-only

src=$(nix-build -A "$attr.src" --no-out-link)

yarn-berry-fetcher missing-hashes "$src/src-gui/yarn.lock" > "$pkgDir/missing-hashes.json"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cp -r --no-preserve=mode "$src" "$work/src"
cd "$work/src"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
git init -q
git add -A

replace() {
  grep -qF -- "$2" "$1" || {
    echo "update.sh: '$2' not found in $1, update use-system-ca-store.patch by hand" >&2
    exit 1
  }
  sed -i "s|$(printf '%s' "$2" | sed 's/[][\.*^$|]/\\&/g')|$3|" "$1"
}

replace Cargo.toml 'bdk = "0.28"' \
  'bdk = { version = "0.28", default-features = false, features = ["std", "key-value-db"] }'
for f in bitcoin-wallet/Cargo.toml electrum-pool/Cargo.toml; do
  replace "$f" 'features = ["use-rustls-ring"]' 'features = ["use-openssl"]'
done
replace swap-feed/Cargo.toml 'features = ["rustls-tls"]' 'features = ["native-tls"]'
for f in swap/Cargo.toml monero-sys/Cargo.toml monero-rpc-pool/Cargo.toml; do
  replace "$f" '"runtime-tokio-rustls"' '"runtime-tokio"'
done

CARGO_HOME="$work/cargo-home" cargo metadata --format-version 1 > /dev/null

git diff > "$pkgDir/use-system-ca-store.patch"

cd "$nixpkgs"
nix-update "$attr" --version skip --subpackage yarnOfflineCache
