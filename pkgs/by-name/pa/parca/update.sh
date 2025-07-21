#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq git pnpm_9
# shellcheck shell=bash
set -euo pipefail
nixpkgs="$(pwd)"
cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

# Update the hash of the parca source code in the Nix expression.
update_parca_source() {
    local version; version="$1"
    echo "Updating parca source"

    old_version="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).parca.version" | jq -r)"
    sed -i "s|${old_version}|${version}|g" package.nix

    old_hash="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).parca.src.outputHash" | jq -r)"
    new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs/default.nix {}).parca.src; in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = \"\"; outputHashAlgo = \"sha256\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true

    sed -i "s|${old_hash}|${new_hash}|g" package.nix
}

# Update the hash of the parca ui pnpm dependencies in the Nix expression.
update_pnpm_deps_hash() {
    echo "Updating parca ui pnpm deps hash"

    old_hash="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).parca.ui.pnpmDeps.outputHash" | jq -r)"
    new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs/default.nix {}).parca.ui.pnpmDeps; in (src.overrideAttrs or (f: src // f src)) (_: { outputHash = \"\"; outputHashAlgo = \"sha256\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true

    sed -i "s|${old_hash}|${new_hash}|g" package.nix
}

# Update the hash of the parca go dependencies in the Nix expression.
update_go_deps_hash() {
    echo "Updating parca go deps hash"

    old_hash="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).parca.vendorHash" | jq -r)"
    new_hash="$(nix-build --impure --expr "let src = (import $nixpkgs/default.nix {}).parca; in (src.overrideAttrs { vendorHash = \"\"; })" 2>&1 | tr -s ' ' | grep -Po "got: \K.+$")" || true

    sed -i "s|${old_hash}|${new_hash}|g" package.nix
}

LATEST_TAG="$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/parca-dev/parca/releases/latest | jq -r '.tag_name')"
LATEST_VERSION="$(expr "$LATEST_TAG" : 'v\(.*\)')"
CURRENT_VERSION="$(nix eval --json --impure --expr "(import $nixpkgs/default.nix {}).parca.version" | jq -r)"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "parca is up to date: ${CURRENT_VERSION}"
    exit 0
fi

update_parca_source "$LATEST_VERSION"
update_pnpm_deps_hash
update_go_deps_hash
