#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl gnused nix

set -euo pipefail

base_url="https://download2.interactivebrokers.com/installers/tws/stable-standalone"
installer_url="$base_url/tws-stable-standalone-linux-x64.sh"

version_json="$(curl -fsSL "$base_url/version.json")"
version="$(sed -nE 's/^twsstable_callback\(\{"buildVersion":"([^"]+)".*/\1/p' <<< "$version_json")"

if [[ -z "$version" ]]; then
    echo "Could not parse upstream version from $base_url/version.json" >&2
    exit 1
fi

prefetch_hash="$(nix-prefetch-url --executable "$installer_url")"
hash="$(nix hash convert --hash-algo sha256 --to sri "$prefetch_hash")"

# --ignore-same-version: IBKR sometimes rotates the installer bytes without
# bumping buildVersion, which must still be re-pinned.
update-source-version ib-tws "$version" "$hash" --ignore-same-version
