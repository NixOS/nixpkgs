#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update common-updater-scripts curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

releaseInfo="`curl_github \
  "https://api.github.com/repos/signalapp/Signal-Desktop/releases/latest"`"

releaseTag="`jq -r ".tag_name" <<< $releaseInfo`"
releaseDate="`jq -r ".created_at" <<< $releaseInfo`"
releaseEpoch=`date -d $releaseDate +%s`

packageJson="`curl_github "https://raw.githubusercontent.com/signalapp/Signal-Desktop/refs/tags/$releaseTag/package.json"`"

latestVersion="`jq -r '.version' <<< $packageJson`"
nodeVersion="`jq -r '.engines.node' <<< $packageJson | head -c2`"
electronVersion="`jq -r '.devDependencies.electron' <<< $packageJson | head -c2`"
libsignalClientVersion=`jq -r '.dependencies."@signalapp/libsignal-client"' <<< $packageJson`
ringrtcVersion=`jq -r '.dependencies."@signalapp/ringrtc"' <<< $packageJson`

sed -E -i "s/(nodejs_)../\1$nodeVersion/" $SCRIPT_DIR/package.nix
sed -E -i "s/(electron_)../\1$electronVersion/" $SCRIPT_DIR/package.nix
sed -E -i "s/(SOURCE_DATE_EPOCH = )[0-9]+/\1$releaseEpoch/" $SCRIPT_DIR/package.nix

sed -E -i "s/(withAppleEmojis \? )false/\1true/" $SCRIPT_DIR/package.nix
nix-update signal-desktop-source --subpackage sticker-creator --version="$latestVersion"
sed -E -i "s/(withAppleEmojis \? )true/\1false/" $SCRIPT_DIR/package.nix
update-source-version signal-desktop-source \
  --ignore-same-version \
  --source-key=pnpmDeps

update-source-version signal-desktop-source.libsignal-node \
  "$libsignalClientVersion"
update-source-version signal-desktop-source.libsignal-node \
  --ignore-same-version \
  --source-key=cargoDeps.vendorStaging
update-source-version signal-desktop-source.libsignal-node \
  --ignore-same-version \
  --source-key=npmDeps

update-source-version signal-desktop-source.ringrtc-bin "$ringrtcVersion"
