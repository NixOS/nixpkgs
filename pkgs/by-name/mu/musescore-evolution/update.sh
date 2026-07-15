#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-update coreutils

set -euo pipefail

# Fallback to default attribute path if not set
attr_path="${UPDATE_NIX_ATTR_PATH:-musescore-evolution}"

# Run nix-update on the default branch (updates rev and sha256)
nix-update $attr_path --version=branch

# Now we need to update the version name

# Find the new version generated from the nix-update command (e.g. "0-unstable-2026-01-12")
generated_version=$(nix eval --raw -f . ${attr_path}.version)

# Extract the last ISO date (YYYY-MM-DD) found in the generated version (e.g. 2026-01-12)
clean_date=$(printf '%s\n' "$generated_version" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | tail -n1 || true)

# Version prefix remains unchanged
prefix="3.7.0-unstable"

new_version="${prefix}-${clean_date}" # (e.g. "3.7.0-unstable-2026-01-12")

# Patch version in nix file
# Strip any existing version line and replace with new one
sed -i "s/version = \".*\"/version = \"${new_version}\"/" $(nix eval --raw -f . ${attr_path}.meta.position | cut -d: -f1)
