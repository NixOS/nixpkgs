#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

changelog_url="https://docs.foxglove.dev/changelog/tags/foxglove"

# Extract the latest version from the changelog page
version=$(
  curl -s "$changelog_url" \
  | grep 'Downloads: ' \
  | grep '<a href="https://get.foxglove.dev/desktop/v' \
  | grep -oP '[0-9]+\.[0-9]+\.[0-9]+' \
  | head -1
)

update-source-version foxglove-studio "$version"
