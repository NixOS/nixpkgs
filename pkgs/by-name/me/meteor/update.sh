#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl nix-update

releaseInfo=$(curl https://install.meteor.com)
latestVersion=$(grep <<<"$releaseInfo" -oP 'RELEASE="\K[^"]+')
currentVersion=$(nix eval --raw -f . meteor.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
   echo "package is up-to-date"
   exit 0
fi

systems=$(nix eval --json -f . meteor.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . meteor.src.url --system "$system")))
  update-source-version meteor $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
done
