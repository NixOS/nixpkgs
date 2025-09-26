#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq git nodejs pnpm sd
# shellcheck shell=bash
set -euo pipefail
nixpkgs="$(pwd)"
cd $(readlink -e $(dirname "${BASH_SOURCE[0]}"))

# Generate the patch file that makes homepage-dashboard aware of the NIXPKGS_HOMEPAGE_CACHE_DIR environment variable.
# Generating the patch this way ensures that both the patch is included, and the lock file is updated.
generate_patch() {
    local version; version="$1"
    echo "Generating homepage-dashboard patch"

    git clone -b "v$version" https://github.com/gethomepage/homepage.git src
    pushd src

    pnpm install
    pnpm patch next
    sd \
      'this.serverDistDir = ctx.serverDistDir;' \
      'this.serverDistDir = require("path").join((process.env.NIXPKGS_HOMEPAGE_CACHE_DIR || "/var/cache/homepage-dashboard"), "homepage");' \
      node_modules/.pnpm_patches/next*/dist/server/lib/incremental-cache/file-system-cache.js
    pnpm patch-commit node_modules/.pnpm_patches/next*

    git add -A .
    git diff -p --staged --no-ext-diff > ../prerender_cache_path.patch

    popd
    rm -rf src
}

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
generate_patch "$LATEST_VERSION"
update_pnpm_deps_hash
