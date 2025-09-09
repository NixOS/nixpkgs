#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
cd "$(dirname "${BASH_SOURCE[0]}")"

# Build and run nix-prefetch-fossil from the local nixpkgs
prefetch_fossil="$(nix-build "$nixpkgs" -A nix-prefetch-scripts --no-out-link 2>/dev/null)/bin/nix-prefetch-fossil"

echo "Fetching latest pikchr revision..." >&2

# Run nix-prefetch-fossil and capture output
output=$("$prefetch_fossil" https://pikchr.org/home trunk 2>&1)

# Extract JSON from output (it's at the end after the blank line)
json_output=$(echo "$output" | awk '/^{/{p=1} p')

# Extract revision and hash
full_rev=$(echo "$json_output" | jq -r '.rev')
new_rev="${full_rev:0:16}"  # Use 16-char prefix for consistency
new_hash=$(echo "$json_output" | jq -r '.hash')
new_version="0-unstable-$(date +%Y-%m-%d)"

echo "Updating pikchr to $new_version (rev $new_rev)" >&2

# Use update-source-version from the nixpkgs root
(
    cd "$nixpkgs"
    update-source-version pikchr "$new_version" "$new_hash" \
        --file="pkgs/by-name/pi/pikchr/package.nix" \
        --rev="$new_rev"
)
