#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -fsSL https://api.github.com/repos/stablyai/orca/releases/latest | jq --raw-output .tag_name)
latestVersion=${latestVersion#v}
currentVersion=$(nix-instantiate --eval --raw -A orca-ide.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "orca-ide is up to date: $currentVersion"
  exit 0
fi

electronMajor=$(curl -fsSL "https://raw.githubusercontent.com/stablyai/orca/v$latestVersion/package.json" | jq --raw-output '.devDependencies.electron | capture("(?<major>[0-9]+)").major')
sed -r "s|(electron_)[0-9]+|\1$electronMajor|" -i pkgs/by-name/or/orca-ide/package.nix

for system in x86_64-linux aarch64-linux; do
  url=$(nix-instantiate --eval --raw -A orca-ide.src.url --argstr system "$system" | sed "s/$currentVersion/$latestVersion/g")
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$url")")
  update-source-version orca-ide "$latestVersion" "$hash" --system="$system" --ignore-same-version
done
