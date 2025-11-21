#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nurl pup common-updater-scripts

# partially taken from jitsi-meet/update.sh, as they both scrape an apt repo.

set -euo pipefail

version="$(curl https://josm.openstreetmap.de/apt/pool/universe/j/josm/ |
  pup 'a[href] text{}' |
  sed -nr 's/josm_[0-9]+.[0-9]+.svn([0-9]+)_all.deb/\1/p' |
  sort -n |
  tail -n1)"

pkgHash="$(nurl -f fetchsvn -H https://josm.openstreetmap.de/svn/trunk/native/linux/tested "$version")"

update-source-version josm "$version" --source-key=srcs.jar
update-source-version josm "$version" --ignore-same-version --source-key=srcs.macosx
update-source-version josm "$version" "$pkgHash" --ignore-same-version --source-key=srcs.pkg
