#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

attr="simplex-chat-desktop"

# Get the latest non-prerelease tag from GitHub.
latest=$(curl -fsSL ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} \
  "https://api.github.com/repos/simplex-chat/simplex-chat/releases/latest" \
  | jq -r '.tag_name')

# Strip the leading "v".
version="${latest#v}"

# Current version in nixpkgs (so we can short-circuit if unchanged).
current=$(nix-instantiate --eval -E "with import ./. {}; ${attr}.version" \
  | tr -d '"')

if [[ "$version" == "$current" ]]; then
  echo "${attr} is already at ${version}"
  exit 0
fi

# Update each per-system source independently.
update-source-version "$attr" "$version" \
    --source-key=sources.x86_64-linux

# --ignore-same-version flag silences warning because previous invocation bumped version
update-source-version "$attr" "$version" \
    --ignore-same-version \
    --source-key=sources.aarch64-linux
