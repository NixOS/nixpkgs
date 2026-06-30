#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
set -euo pipefail

### Fetch latest version from apt repository metadata
new_version=$(curl -sS "https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages" \
  | sed -nE 's/^Version: ([0-9]+\.[0-9]+\.[0-9]+)$/\1/p' \
  | sort -V \
  | tail -n 1)

old_version=$(sed -nE 's/^\s*version = "(.*)";/\1/p' ./package.nix)

if [[ "$new_version" == "$old_version" ]]; then
    echo "claude-desktop: up to date ($old_version)"
    exit 0
fi

echo "claude-desktop: $old_version -> $new_version"

base_url="https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop"

update_hash() {
    local system="$1"
    local arch="$2"
    local url="$base_url/claude-desktop_${new_version}_${arch}.deb"
    local hash
    hash=$(nix-prefetch-url --type sha256 "$url")
    local sri
    sri=$(nix --extra-experimental-features nix-command hash to-sri "sha256:$hash")
    update-source-version claude-desktop "$new_version" "$sri" --system="$system" --ignore-same-version
}

update_hash x86_64-linux amd64
update_hash aarch64-linux arm64
