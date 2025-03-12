#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq libarchive
#shellcheck shell=bash
set -euo pipefail
cd "$(dirname "$0")"
nixpkgs=../../../../../../
node_packages="$nixpkgs/pkgs/development/node-packages"
owner=rust-lang
repo=rust-analyzer
ver=$(
    curl -s "https://api.github.com/repos/$owner/$repo/releases" |
    jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output
)
node_src="$(nix-build "$nixpkgs" -A rust-analyzer.src --no-out-link)/editors/code"

# Check vscode compatibility
req_vscode_ver="$(jq '.engines.vscode' "$node_src/package.json" --raw-output)"
req_vscode_ver="${req_vscode_ver#^}"
cur_vscode_ver="$(nix-instantiate --eval --strict "$nixpkgs" -A vscode.version | tr -d '"')"
if [[ "$(nix-instantiate --eval --strict -E "(builtins.compareVersions \"$req_vscode_ver\" \"$cur_vscode_ver\")")" -gt 0 ]]; then
    echo "vscode $cur_vscode_ver is incompatible with the extension requiring ^$req_vscode_ver"
    exit 1
fi

extension_ver=$(curl "https://github.com/$owner/$repo/releases/download/$ver/rust-analyzer-linux-x64.vsix" -L |
    bsdtar -xf - --to-stdout extension/package.json | # Use bsdtar to extract vsix(zip).
    jq --raw-output '.version')
echo "Extension version: $extension_ver"

# We need devDependencies to build vsix.
# `esbuild` is a binary package an is already in nixpkgs so we omit it here.
jq '{ name, version: $ver, dependencies: (.dependencies + .devDependencies | del(.esbuild)) }' "$node_src/package.json" \
    --arg ver "$extension_ver" \
    >"build-deps/package.json.new"

old_deps="$(jq '.dependencies' build-deps/package.json)"
new_deps="$(jq '.dependencies' build-deps/package.json.new)"
if [[ "$old_deps" == "$new_deps" ]]; then
    echo "package.json dependencies not changed, do simple version change"

    sed -E '/^  "rust-analyzer-build-deps/,+3 s/version = ".*"/version = "'"$extension_ver"'"/' \
        --in-place "$node_packages"/node-packages.nix
    mv build-deps/package.json{.new,}
else
    echo "package.json dependencies changed, updating nodePackages"
    mv build-deps/package.json{.new,}

    ./"$node_packages"/generate.sh
fi

echo "Remember to also update the releaseTag and hash in default.nix!"
