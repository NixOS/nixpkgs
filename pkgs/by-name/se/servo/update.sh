#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils common-updater-scripts curl jq nix-update

# This update script exists, because nix-update is unable to ignore various
# bogus tags that exist on the upstream repo e.g.
#  - selectors-v0.18.0/v0.20.0/v0.21.0/v0.22.0
#  - homu-tmp
#
# Once https://github.com/Mic92/nix-update/issues/322 is resolved it can be
# removed.

set -exuo pipefail

# Determine latest commit id and date
TMP=$(mktemp)
curl -o "$TMP" https://api.github.com/repos/servo/servo/commits/main
COMMIT_ID=$(jq -r '.sha' "$TMP")
COMMIT_TIMESTAMP=$(jq -r '.commit.author.date' "$TMP")
COMMIT_DATE=$(date -d "$COMMIT_TIMESTAMP" +"%Y-%m-%d")
rm $TMP

cd "$(git rev-parse --show-toplevel)"

# Update version, src
update-source-version servo "0-unstable-${COMMIT_DATE}" --file=pkgs/by-name/se/servo/package.nix --rev="$COMMIT_ID"

# Update cargoHash
nix-update --version=skip servo
