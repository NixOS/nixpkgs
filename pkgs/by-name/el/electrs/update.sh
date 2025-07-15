#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq git gnupg common-updater-scripts
set -euo pipefail

# Fetch latest release, GPG-verify the tag, update derivation

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

oldVersion=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).electrs.version" | tr -d '"')
version=$(curl -s --show-error "https://api.github.com/repos/romanz/electrs/releases/latest" | jq -r '.tag_name' | tail -c +2)

if [[ $version == $oldVersion ]]; then
  echo "Already at latest version $version"
  exit 0
fi
echo "New version: $version"

tmpdir=$(mktemp -d /tmp/electrs-verify-gpg.XXX)
repo=$tmpdir/repo
trap "rm -rf $tmpdir" EXIT

git clone --depth 1 --branch v${version} -c advice.detachedHead=false https://github.com/romanz/electrs $repo
git -C $repo checkout tags/v${version}

export GNUPGHOME=$tmpdir
echo
echo "Fetching romanz's key"
gpg --keyserver hkps://keys.openpgp.org --recv-keys 15c8c3574ae4f1e25f3f35c587cae5fa46917cbb 2> /dev/null
echo
echo "Verifying commit"
git -C $repo verify-tag v${version}

rm -rf $repo/.git
hash=$(nix --extra-experimental-features nix-command hash path $repo)

(cd "$nixpkgs" && update-source-version electrs "$version" "$hash" && update-source-version electrs --ignore-same-version --source-key=cargoDeps)
echo
echo "electrs: $oldVersion -> $version"
