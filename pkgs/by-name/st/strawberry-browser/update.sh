#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -euo pipefail

# upstream publishes the current macOS build in a small json endpoint rather than
# tagged releases, so read the version from there and let the templated url follow
version=$(curl -fsSL https://strawberrybrowser.com/api/download/version-info | jq -r '.mac.version')

update-source-version strawberry-browser "$version"
