#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl jq

set -euo pipefail

current_version="$(nix --extra-experimental-features nix-command eval -f . github-mcp-server.version --raw)"
latest_version="$(curl -s -H "Accept: application/vnd.github.v3+json" \
            ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
            "https://api.github.com/repos/github/github-mcp-server/releases/latest" | jq -r ".tag_name")"
latest_version="${latest_version#v}" # v0.17.1 -> 0.17.1

if [[ "$latest_version" == "$current_version" ]]; then
    echo "github-mcp-server is already up to date: $current_version"
    exit 0
fi

echo "Updating github-mcp-server from $current_version to $latest_version"
update-source-version github-mcp-server "$latest_version"

echo "Updating Go modules hash..."
$(nix-build -A github-mcp-server.goModules --no-out-link 2>/dev/null || true)
