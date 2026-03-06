#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-update coreutils

set -euo pipefail

# Run nix-update on the default branch (updates rev and sha256)
nix-update musescore-evolution --version=branch

# Now we need to update the version name

# Find the new version generated from the nix-update command (e.g. "0-unstable-2026-01-12")
generated_version=$(nix eval --raw -f . ${UPDATE_NIX_ATTR_PATH}.version)

# Extract only the date part (after the last dash) (e.g. 0-unstable-2026-01-12)
parts=(${generated_version//-/ }) # Split up by dashes
clean_date="${parts[2]}-${parts[3]}-${parts[4]}" # Get clean date in YYYY-MM-DD format (e.g. "2026-01-12")

# Compute version prefix based on previous version
old_version="$UPDATE_NIX_OLD_VERSION"
prefix="${old_version%-*}" # e.g. "3.7.0-unstable"

new_version="${prefix}-${clean_date}"

# Patch version in nix file
# Strip any existing version line and replace with new one
sed -i "s/version = \".*\"/version = \"${new_version}\"/" $(nix eval --raw -f . ${UPDATE_NIX_ATTR_PATH}.meta.position | cut -d: -f1)
