#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

case "$UPDATE_NIX_ATTR_PATH" in
signal-desktop)
  latestTag=$(curl_github https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest | jq -r ".tag_name")
  latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
  latestVersionAarch64=$(curl_github "https://api.github.com/repos/0mniteck/Signal-Desktop-Mobian/releases/latest" | jq -r ".tag_name")

  echo "Updating signal-desktop for x86_64-linux"
  nix-update --version "$latestVersion" \
    --system x86_64-linux \
    --override-filename "$SCRIPT_DIR/signal-desktop.nix" \
  signal-desktop

  echo "Updating signal-desktop for aarch64-linux"
  nix-update --version "$latestVersionAarch64" \
    --system aarch64-linux \
    --override-filename "$SCRIPT_DIR/signal-desktop-aarch64.nix" \
    signal-desktop
  ;;
signal-desktop-beta)
  latestTagBeta=$(curl_github https://api.github.com/repos/signalapp/Signal-Desktop/releases | jq -r ".[0].tag_name")
  latestVersionBeta="$(expr "$latestTagBeta" : 'v\(.*\)')"
  echo "Updating signal-desktop-beta for x86_64-linux"
  nix-update --version "$latestVersionBeta" --system x86_64-linux --override-filename "$SCRIPT_DIR/signal-desktop-beta.nix" signal-desktop-beta
  ;;
*)
  echo "Unknown attr path $UPDATE_NIX_ATTR_PATH"
  ;;
esac
