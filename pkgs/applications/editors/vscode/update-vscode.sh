#! /usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl gawk gnugrep gnused jq nix nix-prefetch nix-prefetch-scripts common-updater-scripts

# Script to automatically fetch latest vscode

set -eou pipefail

version="${1:-}"

currentVersion=$(nix eval --raw -f . vscode.version)

if [[ -n "$version" ]]; then
  latestVersion="$version"
else
  latestVersion=$(curl --fail --silent https://api.github.com/repos/Microsoft/vscode/releases | jq --raw-output 'map(select(.prerelease==false)) | .[].tag_name' | sort -V | tail -n1)
  if ! [[ "$latestVersion" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version from GitHub API: $latestVersion"
    exit 1
  fi
fi

echo "target   version: $latestVersion"
echo "current version: $currentVersion"

minVersion=$(printf '%s\n' "$currentVersion" "$latestVersion" | sort -V | head -n1)
if [[ "$minVersion" == "$latestVersion" ]] && [[ "$latestVersion" != "$currentVersion" ]]; then
  echo "Error: target version '$latestVersion' is less than current version '$currentVersion'"
  exit 1
fi

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

update-source-version vscode $latestVersion

systems=$(nix eval --json -f . vscode.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . vscode.src.url --system "$system")))
  update-source-version vscode $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
done

rev=$(curl --fail --silent https://api.github.com/repos/Microsoft/vscode/git/ref/tags/$latestVersion | jq --raw-output .object.sha)
vscodeServerHash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url https://update.code.visualstudio.com/commit:$rev/server-linux-x64/stable))
update-source-version vscode $rev $vscodeServerHash --version-key=rev --source-key=vscodeServer.src --ignore-same-version --ignore-same-hash

echo ""
echo "Update complete! To test the changes:"
echo "  1. Close any running VS Code instances"
echo "  2. Run: NIXPKGS_ALLOW_UNFREE=1 nix run -f . vscode"
