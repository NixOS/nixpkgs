#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts git jq curl

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

rev=`curl -L https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/master/pkgs/applications/networking/browsers/chromium/info.json | jq -r '.chromium.deps.gn.rev'`

tmpdir="$(mktemp -d)"
git clone "https://gn.googlesource.com/gn" "$tmpdir"

pushd "$tmpdir"
git checkout $rev
commit_date=`git show -s --pretty='format:%cs'`
rev_num=`git describe --match initial-commit | cut -d- -f3`
popd

sed -E -i "s/(revNum = )[0-9]+/\1$rev_num/" $SCRIPT_DIR/package.nix
update-source-version gn "0-unstable-$commit_date" --rev=$rev
