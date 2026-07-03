#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p gh jq
# shellcheck shell=bash
set -euo pipefail

nixpkgs="$(pwd)"
cd "$(readlink -e "$(dirname "${BASH_SOURCE[0]}")")"

nix_attr() { nix eval --json --impure --expr "(import $nixpkgs {}).$1" | jq -r; }

update_hash() {
  old_hash="$(nix_attr "$1.outputHash")"
  new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs {}).$1; in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = \"\"; outputHashAlgo = \"sha256\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true
  sed -i "s|${old_hash}|${new_hash}|g" package.nix
  echo "$1: $old_hash -> $new_hash"
}

latest=$(gh api repos/inngest/inngest/releases/latest --jq '.tag_name' | tr -d 'v')
current=$(nix_attr inngest.version)

if [[ "$current" == "$latest" ]]; then
  echo "inngest is already up to date: $current"
  exit 0
fi

echo "Updating inngest $current -> $latest"

sed -i "s|version = \"${current}\"|version = \"${latest}\"|" package.nix
update_hash inngest.src

old_lock=$(gh api "repos/inngest/inngest/contents/ui/pnpm-lock.yaml?ref=v${current}" --jq '.sha')
new_lock=$(gh api "repos/inngest/inngest/contents/ui/pnpm-lock.yaml?ref=v${latest}" --jq '.sha')
if [[ "$old_lock" != "$new_lock" ]]; then
  update_hash inngest.ui.pnpmDeps
else
  echo "pnpm lockfile unchanged, skipping"
fi

new_rev=$(gh api "repos/inngest/inngest/contents/internal/embeddocs/website?ref=v${latest}" --jq '.sha')
old_rev=$(nix_attr inngest.websiteRev)
if [[ "$old_rev" != "$new_rev" ]]; then
  sed -i "s|${old_rev}|${new_rev}|" package.nix
  update_hash inngest.website
else
  echo "website unchanged, skipping"
fi
