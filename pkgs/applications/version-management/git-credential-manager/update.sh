#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch nix coreutils gnused

cd "$(dirname "$0")"

set -euo pipefail

latestVersion="$(curl -s "https://api.github.com/repos/git-ecosystem/git-credential-manager/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion="$(nix-instantiate --eval -E "with import ../../../.. {}; git-credential-manager.version" | tr -d '"')"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "up to date"
    exit 0
fi

echo "updating $currentVersion -> $latestVersion"

sed -i -e "s/version = \"${currentVersion}\"/version = \"${latestVersion}\"/" default.nix
hash="$(nix-prefetch ./.)"
sed -i -Ee "s/hash = \"sha256-[A-Za-z0-9=]{44}\"/hash = \"${hash}\"/" default.nix


$(nix-build ../../../.. -A git-credential-manager.fetch-deps --no-out-link)
