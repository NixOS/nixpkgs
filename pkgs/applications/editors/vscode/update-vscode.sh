#! /usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl gawk gnugrep gnused jq nix nix-prefetch nix-prefetch-scripts common-updater-scripts

set -eou pipefail

latestVersion=$(curl --fail --silent https://api.github.com/repos/Microsoft/vscode/releases/latest | jq --raw-output .tag_name)
currentVersion=$(nix eval --raw -f . vscode.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

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
update-source-version vscode $rev --version-key=rev --source-key=vscodeServer.src --ignore-same-version --ignore-same-hash
