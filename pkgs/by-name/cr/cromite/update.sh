#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix bash coreutils nix-update

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/uazo/cromite/releases/latest | jq --raw-output .tag_name | sed 's/^v//')
latestVersion="${latestTag%-*}"
commit="${latestTag#*-}"

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; cromite.version or (lib.getVersion cromite)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update_nix_value() {
    local key="$1"
    local value="${2:-}"
    sed -i "s|$key = \".*\"|$key = \"$value\"|" $ROOT/package.nix
}

update_nix_value version $latestVersion
update_nix_value commit $commit

nix-update cromite --version skip
