#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl -s https://api.github.com/repos/mongodb-js/compass/releases/latest | jq -r .tag_name | sed 's/^v//')

if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
  echo "mongodb-compass is already up-to-date: $latestVersion"
  exit 0
fi

update-source-version mongodb-compass "$latestVersion"

systems=$(nix eval --json -f . mongodb-compass.meta.platforms | jq -r '.[]')
for system in $systems; do
  url=$(nix eval --raw -f . mongodb-compass.src.url --system "$system")
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "$url"))
  update-source-version mongodb-compass "$latestVersion" "$hash" --system=$system --ignore-same-version --ignore-same-hash
done
