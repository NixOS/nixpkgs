#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq git
# shellcheck shell=bash
set -euo pipefail
nixpkgs="$(pwd)"
cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

# Update the hash of the homepage-dashboard source code in the Nix expression.
update_homepage_dashboard_source() {
    local version; version="$1"
    echo "Updating homepage-dashboard source"

    old_version="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).homepage-dashboard.version" | jq -r)"
    sed -i "s|${old_version}|${version}|g" package.nix

    old_hash="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).homepage-dashboard.src.outputHash" | jq -r)"
    new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs/default.nix {}).homepage-dashboard.src; in (src.overrideAttrs or (f: src // f src)) (_: { version = \"$version\"; outputHash = \"\"; outputHashAlgo = \"sha256\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true
    sed -i "s|${old_hash}|${new_hash}|g" package.nix
}

# Update the hash of the homepage-dashboard pnpm dependencies in the Nix expression.
update_pnpm_deps_hash() {
    echo "Updating homepage-dashboard pnpm deps hash"

    old_hash="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).homepage-dashboard.pnpmDeps.outputHash" | jq -r)"
    new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs/default.nix {}).homepage-dashboard.pnpmDeps; in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = \"\"; outputHashAlgo = \"sha256\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true

    sed -i "s|${old_hash}|${new_hash}|g" package.nix
}

LATEST_TAG="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/gethomepage/homepage/releases/latest | jq -r '.tag_name')"
LATEST_VERSION="$(expr "$LATEST_TAG" : 'v\(.*\)')"
CURRENT_VERSION="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).homepage-dashboard.version" | jq -r)"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "homepage-dashboard is up to date: ${CURRENT_VERSION}"
    exit 0
fi

update_homepage_dashboard_source "$LATEST_VERSION"
update_pnpm_deps_hash
