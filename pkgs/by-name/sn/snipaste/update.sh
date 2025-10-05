#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts

latestTag=$(curl -sSfL https://www.snipaste.com/linux_version | jq -r ".subject")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; snipaste.version" | tr -d '"')

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

prefetch=$(nix-prefetch-url "https://download.snipaste.com/archives/Snipaste-$latestVersion-x86_64.AppImage")
hash=$(nix-hash --type sha256 --to-sri "$prefetch")
update-source-version snipaste "$latestVersion" "$hash" --ignore-same-version
