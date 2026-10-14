#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq git gnupg common-updater-scripts
set -euo pipefail

trap 'echo "Error at ${BASH_SOURCE[0]}:$LINENO"' ERR

# Fetch latest release, SSH-verify the tag, update derivation

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

oldVersion=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).electrs.version" | tr -d '"')
version=$(curl -s --show-error "https://api.github.com/repos/romanz/electrs/releases/latest" | jq -r '.tag_name' | tail -c +2)

if [[ $version == "$oldVersion" ]]; then
  echo "Already at latest version $version"
  exit 0
fi
echo "New version: $version"

tmpdir=$(mktemp -d "/tmp/electrs-verify-ssh.XXXXXX")
repo="${tmpdir}/repo"
trap 'rm -rf "$tmpdir"' EXIT

git clone --depth 1 --branch "v${version}" -c advice.detachedHead=false https://github.com/romanz/electrs "$repo"
git -C "$repo" checkout "tags/v${version}"

echo
echo "Configuring allowed signers for SSH tag verification"

# Romanz's public SSH Key from: https://github.com/romanz/keys
echo "git@romanzey.de ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZVq/3fgkildjN/MqEnhrP5550sDpFzGxMwevr5q/9w" > "${tmpdir}/allowed_signers"
git -C "$repo" config gpg.format ssh
git -C "$repo" config gpg.ssh.allowedSignersFile "$tmpdir/allowed_signers"

echo
echo "Verifying tag"
git -C "$repo" verify-tag "v${version}"

rm -rf "$repo/.git"
hash=$(nix --extra-experimental-features nix-command hash path "$repo")

(cd "$nixpkgs" && update-source-version electrs "$version" "$hash" && update-source-version electrs --ignore-same-version --source-key=cargoDeps.vendorStaging)
echo
echo "electrs: $oldVersion -> $version"
