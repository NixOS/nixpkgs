#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl nix-update jq

set -euo pipefail

nix-update

cd "$(dirname "$0")"

nixpkgs=../../../..
node_packages="$nixpkgs/pkgs/development/node-packages"
pgrok="$nixpkgs/pkgs/by-name/pg/pgrok"

TARGET_VERSION_REMOTE=$(curl -s https://api.github.com/repos/pgrok/pgrok/releases/latest | jq -r ".tag_name")
TARGET_VERSION=${TARGET_VERSION_REMOTE#v}

SRC_FILE_BASE="https://raw.githubusercontent.com/pgrok/pgrok/v$TARGET_VERSION"

# replace ^ versions with ~, replace outdir to dist
curl https://raw.githubusercontent.com/pgrok/pgrok/main/pgrokd/web/package.json \
    | jq "{name,scripts,version: \"${TARGET_VERSION}\",dependencies: (.dependencies + .devDependencies) }" \
    | sed -e 's/"\^/"~/g' -e 's/\.\.\/cli\/dist/dist/g' \
    > "$pgrok/build-deps/package.json.new"

old_deps="$(jq '.dependencies' "$pgrok/build-deps/package.json")"
new_deps="$(jq '.dependencies' "$pgrok/build-deps/package.json.new")"

if [[ "$old_deps" == "$new_deps" ]]; then
    echo "package.json dependencies not changed, do simple version change"

    sed -e '/^  "pgrok-build-deps/,+3 s/version = ".*"/version = "'"$TARGET_VERSION"'"/' \
        --in-place "$node_packages"/node-packages.nix
    mv build-deps/package.json{.new,}
else
    echo "package.json dependencies changed, updating nodePackages"
    mv build-deps/package.json{.new,}

    ./"$node_packages"/generate.sh
fi

