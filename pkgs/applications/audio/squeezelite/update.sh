#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -I nixpkgs=./. -i bash -p common-updater-scripts coreutils curl gnused jq nix nix-prefetch-git nix-prefetch-github ripgrep
=======
#!nix-shell -i bash -p common-updater-scripts coreutils curl gnused jq nix nix-prefetch-github ripgrep
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

set -euo pipefail

latestRev="$(curl -s "https://api.github.com/repos/ralph-irving/squeezelite/commits?per_page=1" | jq -r ".[0].sha")"
latestVersion="$( curl -s https://raw.githubusercontent.com/ralph-irving/squeezelite/${latestRev}/squeezelite.h | rg 'define (MAJOR|MINOR|MICRO)_VERSION' | sed 's/#.*VERSION //' | tr '\n' '.' | sed  -e 's/"//g' -e 's/\.$//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; squeezelite.version or (lib.getVersion squeezelite)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "squeezelite is up-to-date: $currentVersion"
  exit 0
fi

<<<<<<< HEAD
srcHash=$(nix-prefetch-github ralph-irving squeezelite --rev "$latestRev" | jq -r .hash)
=======
srcHash=$(nix-prefetch-github ralph-irving squeezelite --rev "$latestRev" | jq -r .sha256)
srcHash=$(nix hash to-sri --type sha256 "$srcHash")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)


update-source-version squeezelite "$latestVersion" "$srcHash" --rev="${latestRev}"
