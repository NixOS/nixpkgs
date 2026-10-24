#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
file="pkgs/by-name/co/connectiq-sdk/package.nix"
cd "$nixpkgs"

latest="$(
  curl -fsSL https://developer.garmin.com/downloads/connect-iq/sdks/sdks.json |
    jq -c 'map(select(.linux != null)) | max_by(.version | split(".") | map(tonumber))'
)"
version="$(jq -r .version <<<"$latest")"
archive="$(jq -r .linux <<<"$latest")"
build="${archive#connectiq-sdk-lin-"$version"-}"
build="${build%.zip}"

current="$(nix-instantiate --eval --raw -A connectiq-sdk.version)"
if [[ "$version" == "$current" ]]; then
  echo "connectiq-sdk is already up to date ($current)" >&2
  exit 0
fi

sed -i "s|build = \".*\";|build = \"$build\";|" "$file"
update-source-version connectiq-sdk "$version" --file="$file"
