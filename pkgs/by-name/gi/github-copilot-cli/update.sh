#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix jq curl gnused

set -euo pipefail

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; github-copilot-cli.version or (lib.getVersion github-copilot-cli)" | tr -d '"')
latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/github/copilot-cli/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "package is up-to-date: $currentVersion"
  exit 0
fi

update-source-version github-copilot-cli $latestVersion || true

declare -a systems=(x86_64-linux aarch64-linux aarch64-darwin)
for system in "${systems[@]}"; do
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp"/github-copilot-cli "$(nix-instantiate --eval -E "with import ./. {}; github-copilot-cli.src.url" --system "$system" | tr -d '"')"
  hash=$(nix --extra-experimental-features nix-command hash file "$tmp"/github-copilot-cli)
  update-source-version github-copilot-cli "$latestVersion" "$hash" --system="$system" --ignore-same-version
  rm -rf "$tmp"
done
