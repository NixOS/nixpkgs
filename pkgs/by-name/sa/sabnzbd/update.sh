#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix common-updater-scripts gnugrep gnused nurl

# shellcheck shell=bash

set -euo pipefail

latestVersion=$(list-git-tags --url=https://github.com/sabnzbd/sabnzbd | grep -E '^[0-9.]+$' | sort --reverse --numeric-sort | head -n 1)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sabnzbd.version or (lib.getVersion sabnzbd)" | tr -d '"')

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "sabnzbd already latest version $latestVersion"
    exit 0
fi

echo "sabnzbd updating $currentVersion -> $latestVersion"
update-source-version sabnzbd "$latestVersion"

sabctoolsVersion=$(curl -s "https://raw.githubusercontent.com/sabnzbd/sabnzbd/$latestVersion/requirements.txt" | grep sabctools | cut -f 3 -d =)
sabctoolsHash=$(nurl --hash https://pypi.org/project/sabctools "$sabctoolsVersion")

sed -i -E -e "s#sabctoolsVersion = \".*\"#sabctoolsVersion = \"$sabctoolsVersion\"#" ./pkgs/by-name/sa/sabnzbd/package.nix
sed -i -E -e "s#sabctoolsHash = \".*\"#sabctoolsHash = \"$sabctoolsHash\"#" ./pkgs/by-name/sa/sabnzbd/package.nix
