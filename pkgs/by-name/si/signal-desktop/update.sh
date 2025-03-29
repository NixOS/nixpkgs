#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

latestTag=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} \
  "https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest" \
  | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

latestBuildInfoAarch64=$(curl \
  "https://copr.fedorainfracloud.org/api_3/package/?ownername=useidel&projectname=signal-desktop&packagename=signal-desktop&with_latest_succeeded_build=true" \
  | jq '.builds.latest_succeeded')
latestBuildAarch64=$(jq '.id' <<< $latestBuildInfoAarch64)
latestVersionAarch64=$(jq -r '.source_package.version' <<< $latestBuildInfoAarch64)

echo "Updating signal-desktop for x86_64-linux"
update-source-version signal-desktop "$latestVersion" \
  --system=x86_64-linux \
  --file="$SCRIPT_DIR/signal-desktop.nix"

echo "Updating signal-desktop for aarch64-linux"
update-source-version signal-desktop "$latestVersionAarch64" "" \
  "https://download.copr.fedorainfracloud.org/results/useidel/signal-desktop/fedora-42-aarch64/$(printf "%08d" $latestBuildAarch64)-signal-desktop/signal-desktop-$latestVersionAarch64.fc42.aarch64.rpm" \
  --system=aarch64-linux \
  --file="$SCRIPT_DIR/signal-desktop-aarch64.nix"

echo "Updating signal-desktop for darwin"
update-source-version signal-desktop "$latestVersion" \
  --system=aarch64-darwin \
  --file="$SCRIPT_DIR/signal-desktop-darwin.nix"
