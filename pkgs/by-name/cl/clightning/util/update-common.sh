#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq common-updater-scripts git gnupg
set -euo pipefail

trap 'echo "Error at ${BASH_SOURCE[0]}:$LINENO"' ERR

pkgName=$1

: "${getVersionFromTags:=}"
: "${refetch:=}"

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../../..)

evalNixpkgs() {
  nix eval --impure --raw --expr "(with import \"$nixpkgs\" {}; $1)"
}

repo=$(evalNixpkgs "$pkgName.meta.homepage" | awk -F/ '{print $(NF-1)"/"$NF}')

getLatestVersionTag() {
  "$nixpkgs"/pkgs/common-updater/scripts/list-git-tags --url="https://github.com/${repo}" 2>/dev/null \
    | grep -E '^v[0-9]' \
    | sort -V | tail -1 | sed 's|^v||'
}

oldVersion=$(evalNixpkgs "$pkgName.version")
if [[ $getVersionFromTags ]]; then
  newVersion=$(getLatestVersionTag)
else
  newVersion=$(curl -s "https://api.github.com/repos/${repo}/releases" | jq -r '.[0].tag_name' | sed 's|^v||')
fi

if [[ $newVersion == "$oldVersion" && ! $refetch ]]; then
  echo "nixpkgs already has the latest version $newVersion"
  exit 0
fi

tmpdir=$(mktemp -d "/tmp/${pkgName}-verify.XXX")
trap 'rm -rf "$tmpdir"' EXIT

baseUrl="https://github.com/${repo}/releases/download/v${newVersion}"
archiveName="${pkgName}-v${newVersion}.zip"
sumName="SHA256SUMS-v${newVersion}"
ascName="${sumName}.asc"

echo "Downloading release files for v${newVersion}..."
curl -sL -o "$tmpdir/$archiveName" "$baseUrl/$archiveName"
curl -sL -o "$tmpdir/$sumName" "$baseUrl/$sumName"
curl -sL -o "$tmpdir/$ascName" "$baseUrl/$ascName"

export GNUPGHOME="$tmpdir/gnupg"
mkdir -p "$GNUPGHOME" && \
  chmod 700 "$GNUPGHOME"

importKey() {
  local fp=$1
  echo "Fetching key: $fp"
    gpg --batch --keyserver hkps://pgp.mit.edu --recv-keys "$fp"  || \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$fp" || \
        echo "Warning: Could not fetch key $fp from keyservers."
}

# Keys from: https://github.com/ElementsProject/lightning/blob/master/SECURITY.md
fingerprints=(
  # Alex Myers
  "04374E42789BBBA9462E4767F3BF63F2747436AB"
  # Peter Neuroth
  "653B19F33DF7EFF3E9D1C94CC3F21EE387FF4CD2"
  # Shahana Farooqui
  "0CCA8183C13A2389A9C5FD29BFB015360049CB56"
  # Madeline Paech
  "7169D26272B50A3F531AA1C2A57AFC231B580804"
  # Sangbida Chaudhuri
  "1A371C2C30645FAA91AA6B7DB643E61284221961"
  # Lagrang3
  "C491580878207F03C3B966F9B4088CD4608A7CA1"
  # daywalker90
  "8A079421A871D0B1083511937AB4802ED5A639F3"
  # Níckolas Goline
  "A57656F8004F6FD68ED99C85BE277A87802A6F08"
  # jaonoctus
  "7B696A616F731337520B8A19D8F31505B581D617"
  # Blockstream CLN Release
  "616C52F99D0612B2A151B1074129A994AA7E9852"
)

for fp in "${fingerprints[@]}"; do
  importKey "$fp"
done

echo
echo "Verifying GPG signature of SHA256SUMS..."
gpg --batch --verify "$tmpdir/$ascName" "$tmpdir/$sumName"

echo
echo "Verifying archive checksum against signed manifest..."
(
  cd "$tmpdir"
  sha256sum --ignore-missing -c "$sumName"
)

newHash=$(nix --extra-experimental-features nix-command hash file "$tmpdir/$archiveName")

echo
echo "Updating $pkgName: $oldVersion -> $newVersion"
(cd "$nixpkgs" && update-source-version "$pkgName" "$newVersion" "$newHash" --ignore-same-version)
echo
