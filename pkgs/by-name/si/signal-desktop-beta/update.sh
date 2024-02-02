#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

latestTagBeta=$(curl_github https://api.github.com/repos/signalapp/Signal-Desktop/releases | jq -r ".[0].tag_name")
latestVersionBeta="$(expr "$latestTagBeta" : 'v\(.*\)')"

echo "Updating signal-desktop-beta for x86_64-linux"
nix-update --version "$latestVersionBeta" \
    --system x86_64-linux \
    --override-filename "$SCRIPT_DIR/package.nix" \
    signal-desktop-beta
