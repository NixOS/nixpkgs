#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq libarchive
#shellcheck shell=bash
set -euo pipefail
cd "$(dirname "$0")"
nixpkgs=../../../../../../
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

vsix_url="https://github.com/$owner/$repo/releases/download/$ver/rust-analyzer-linux-x64.vsix"
extension_ver=$(curl $vsix_url -L |
    bsdtar -xf - --to-stdout extension/package.json | # Use bsdtar to extract vsix(zip).
    jq --raw-output '.version')
echo $extension_ver > version.txt
echo "Extension version: $extension_ver"

echo "Remember to also update the releaseTag and hash in default.nix!"
echo "The releaseTag should be set to $ver"
