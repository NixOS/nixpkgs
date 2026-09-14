#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl nixVersions.latest common-updater-scripts

set -euo pipefail

attr="soundsource"
here=$(cd "$(dirname "$0")" && pwd)
nixFile="$here/package.nix"

cdnUrl="https://cdn.rogueamoeba.com/soundsource/download/SoundSource.zip"
releaseNotesUrl="https://rogueamoeba.com/support/releasenotes/?product=SoundSource"

oldVersion=$(grep -oE 'version = "[0-9.]+"' "$nixFile" | grep -oE '[0-9]+(\.[0-9]+)+' | head -n1)

latest=$(curl -sSf --max-time 60 "$releaseNotesUrl" \
  | grep -oE '>[0-9]+\.[0-9]+\.[0-9]+<' \
  | tr -d '><' \
  | head -n1)

if [[ -z "$latest" ]]; then
  echo "$attr: could not parse latest version from $releaseNotesUrl" >&2
  exit 1
fi

echo "$attr: current=$oldVersion latest=$latest"
if [[ "$latest" == "$oldVersion" ]]; then
  echo "$attr: already up to date"
  exit 0
fi

# No versioned upstream URL exists, so we pin an immutable Wayback Machine
# snapshot of the rolling "latest" build
echo "$attr: archiving $cdnUrl into the Wayback Machine ..."
snapshotUrl=$(curl -sSL --max-time 600 -o /dev/null -w '%{url_effective}' \
  "https://web.archive.org/save/$cdnUrl")
case "$snapshotUrl" in
  https://web.archive.org/web/*) : ;;
  *)
    echo "$attr: unexpected Wayback Machine response: '$snapshotUrl'" >&2
    exit 1
    ;;
esac
echo "$attr: snapshot = $snapshotUrl"

prefetch=$(nix-prefetch-url --unpack --print-path "$snapshotUrl")
rawHash=$(echo "$prefetch" | head -n1)
storePath=$(echo "$prefetch" | tail -n1)
hash=$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 --to sri "$rawHash")

# Verify the archived build is really $latest
zipVersion=$(grep -A1 CFBundleShortVersionString "$storePath/Contents/Info.plist" \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
  | head -n1)

if [[ "$zipVersion" != "$latest" ]]; then
  echo "$attr: version mismatch - release notes say $latest but the archived build is $zipVersion" >&2
  echo "$attr: refusing to pin; re-run once upstream is consistent" >&2
  exit 1
fi

export NIXPKGS_ALLOW_UNFREE=1
update-source-version "$attr" "$latest" "$hash" "$snapshotUrl" --file="$nixFile" --ignore-same-version
