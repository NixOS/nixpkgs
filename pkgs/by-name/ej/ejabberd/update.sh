#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts "rebar3WithPlugins {globalPlugins = [beamPackages.rebar3-nix];}" erlang autoconf automake
#shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/processone/ejabberd/releases/latest | jq -e -r .tag_name)
old_version=$(nix-instantiate --eval -A ejabberd.version | jq -e -r)

if [[ $version == "$old_version" ]]; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

update-source-version ejabberd "$version"

sqlite=$(nix-build . -A sqlite.dev --no-link)
rebardeps=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")/rebar-deps.nix
tmpdir=$(mktemp -d)
cp -r $(nix-build . --no-out-link -A ejabberd.src)/. "$tmpdir"
cd "$tmpdir"

./autogen.sh
./configure --enable-all --disable-elixir --with-sqlite3=$sqlite
HOME=. rebar3 nix lock -o "$rebardeps"
nixfmt "$rebardeps"
