#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq common-updater-scripts nixfmt-rfc-style
set -eo pipefail

verlte() {
    printf '%s\n' "$1" "$2" | sort -C -V
}

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases" |
    jq -r  'map(select(.prerelease == false)) | .[0].tag_name' |
    cut -c2-)"
old_version="$(nix --extra-experimental-features 'nix-command' eval --file default.nix opentabletdriver.version --raw)"

if verlte "$new_version" "$old_version"; then
  echo "Already up to date!"
  [[ "${1}" != "--force" ]] && exit 0
fi

update-source-version opentabletdriver "$new_version"
eval "$(nix-build -A opentabletdriver.fetch-deps --no-out-link)"

cd "$(dirname "${BASH_SOURCE[0]}")"
nixfmt deps.nix
