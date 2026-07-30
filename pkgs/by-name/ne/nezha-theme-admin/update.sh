#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update curl nodejs

set -euo pipefail

version=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/nezhahq/admin-frontend/releases/latest | jq -r ".tag_name")
version=${version#v}

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf -- "${TMPDIR}"' EXIT

git clone "https://github.com/nezhahq/admin-frontend" -b "v$version" "$TMPDIR/src"
pushd "$TMPDIR/src"
rm package-lock.json
npm install --package-lock-only --ignore-scripts
popd

cp "$TMPDIR/src/package-lock.json" pkgs/by-name/ne/nezha-theme-admin/

nix-update "$UPDATE_NIX_ATTR_PATH"
