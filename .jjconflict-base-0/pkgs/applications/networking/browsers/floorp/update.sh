#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-prefetch-github jq gnused

set -e

owner=Floorp-Projects
repo=Floorp
dirname="$(dirname "$0")"

updateVersion() {
    sed -i "s/packageVersion = \"[0-9.]*\";/packageVersion = \"$1\";/g" "$dirname/default.nix"
}

updateBaseVersion() {
    local base
    base=$(curl -s "https://raw.githubusercontent.com/$owner/$repo/v$1/browser/config/version.txt")
    sed -i "s/version = \"[0-9.]*\";/version = \"$base\";/g" "$dirname/default.nix"
}

updateHash() {
    local hash
    hash=$(nix-prefetch-github --fetch-submodules --rev "v$1" $owner $repo | jq -r .hash)
    sed -i "s|hash = \"[a-zA-Z0-9\/+-=]*\";|hash = \"$hash\";|g" "$dirname/default.nix"
}

currentVersion=$(cd "$dirname" && nix eval --raw -f ../../../../.. floorp.version)

latestTag=$(curl -s https://api.github.com/repos/Floorp-Projects/Floorp/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Floorp is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion "$latestVersion"
updateBaseVersion "$latestVersion"
updateHash "$latestVersion"
