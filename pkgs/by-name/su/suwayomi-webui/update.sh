#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git gnused nix-prefetch-git nix-update

set -e

dirname="$(dirname "$0")"

currentVersion=$(cd $dirname && nix eval --raw -f ../../.. suwayomi-webui.version)

git clone "https://github.com/Suwayomi/Suwayomi-WebUI.git"
cd Suwayomi-WebUI

latestTag=$(git tag | sort -r | head -1)
latestVersion=$(expr $latestTag : 'v\(.*\)')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Suwayomi-WebUI is up-to-date: ${currentVersion}"
    exit 0
fi

git checkout $latestTag
revision=$(git rev-list HEAD --count)

sed -i "s/revision = \"[0-9]*\";/revision = \"$revision\";/g" "$dirname/package.nix"

nix-update "$@"
