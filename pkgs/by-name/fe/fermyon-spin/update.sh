#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused nix-update

set -euo pipefail

PACKAGE_DIR="pkgs/by-name/fe/fermyon-spin"
PACKAGE_FILE="$PACKAGE_DIR/package.nix"

# 1. Fetch latest release tag and commit metadata from GitHub
LATEST_TAG=$(curl -s "https://api.github.com/repos/spinframework/spin/releases/latest" | jq -r .tag_name)
LATEST_VERSION="${LATEST_TAG#v}"

COMMIT_DATA=$(curl -s "https://api.github.com/repos/spinframework/spin/commits/$LATEST_TAG")
GIT_SHA=$(echo "$COMMIT_DATA" | jq -r '.sha[0:8]')
GIT_DATE=$(echo "$COMMIT_DATA" | jq -r '.commit.committer.date[0:10]')
GIT_TIMESTAMP=$(echo "$COMMIT_DATA" | jq -r '.commit.committer.date')

# 2. Run nix-update to bump version, src hash, and cargoHash
nix-update --version "$LATEST_VERSION" fermyon-spin

# 3. Update the VERGEN environment variables in package.nix
sed -i -E "s/VERGEN_GIT_SHA = \"[^\"]+\";/VERGEN_GIT_SHA = \"$GIT_SHA\";/" "$PACKAGE_FILE"
sed -i -E "s/VERGEN_GIT_COMMIT_DATE = \"[^\"]+\";/VERGEN_GIT_COMMIT_DATE = \"$GIT_DATE\";/" "$PACKAGE_FILE"
sed -i -E "s/VERGEN_GIT_COMMIT_TIMESTAMP = \"[^\"]+\";/VERGEN_GIT_COMMIT_TIMESTAMP = \"$GIT_TIMESTAMP\";/" "$PACKAGE_FILE"
