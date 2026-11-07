#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix

set -euo pipefail

latest_version=$(
    curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/chromium/chromium/tags" \
        | jq -r 'map(select(.prerelease | not)) | .[1].name'
)

hash=$(
    nix-prefetch-url "https://raw.github.com/chromium/chromium/$latest_version/net/http/transport_security_state_static.json"
)
sri_hash=$(nix hash convert --hash-algo sha256 --to sri "$hash")

cd "$(dirname "$0")/../../../.."
update-source-version chromium-hsts-preload-list "$latest_version" "$sri_hash"
