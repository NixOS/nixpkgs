#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

latestTag=$(curl_github https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
latestVersionAarch64=$(curl_github "https://api.github.com/repos/0mniteck/Signal-Desktop-Mobian/releases/latest" | jq -r ".tag_name")

echo "Updating signal-desktop for x86_64-linux"
nix-update --version "$latestVersion" \
  --system x86_64-linux \
  --override-filename "$SCRIPT_DIR/x86_64.nix" \
  signal-desktop

echo "Updating signal-desktop for aarch64-linux"
nix-update --version "$latestVersionAarch64" \
  --system aarch64-linux \
  --override-filename "$SCRIPT_DIR/aarch64.nix" \
  signal-desktop
