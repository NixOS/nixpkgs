#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl gnused jq nix nix-prefetch-github ripgrep

set -euo pipefail

latestRev="$(curl -s "https://api.github.com/repos/ralph-irving/squeezelite/commits?per_page=1" | jq -r ".[0].sha")"
latestVersion="$( curl -s https://raw.githubusercontent.com/ralph-irving/squeezelite/${latestRev}/squeezelite.h | rg 'define (MAJOR|MINOR|MICRO)_VERSION' | sed 's/#.*VERSION //' | tr '\n' '.' | sed  -e 's/"//g' -e 's/\.$//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; squeezelite.version or (lib.getVersion squeezelite)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "squeezelite is up-to-date: $currentVersion"
  exit 0
fi

srcHash=$(nix-prefetch-github ralph-irving squeezelite --rev "$latestRev" | jq -r .sha256)
srcHash=$(nix hash to-sri --type sha256 "$srcHash")


update-source-version squeezelite "$latestVersion" "$srcHash" --rev="${latestRev}"
