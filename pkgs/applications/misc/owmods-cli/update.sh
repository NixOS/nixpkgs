#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch nix-prefetch-github jq wget

#modified version of https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/servers/readarr/update.sh
set -e

dirname="$(dirname "$0")"

updateHash()
{
    version=$1

    url="https://github.com/ow-mods/ow-mod-man/releases/cli_v$version"
    prefetchJson=$(nix-prefetch-github ow-mods ow-mod-man --rev cli_v$version)
    sha256="$(echo $prefetchJson | jq -r ".sha256")"
    echo "sha256=${sha256}"

    sed -i "s/hash = \"[a-zA-Z0-9\/+-=]*\";/hash = \"sha256-$sha256\";/g" "$dirname/default.nix"

    #downloads and replaces .lock file
    wget https://raw.githubusercontent.com/ow-mods/ow-mod-man/cli_v$version/Cargo.lock -q -O $dirname/Cargo.lock

}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

latestTag=$(curl https://api.github.com/repos/ow-mods/ow-mod-man/releases | jq -r ".[0].tag_name")
latestVersion="$(expr $latestTag : 'gui_v\(.*\)')"
echo "latest version: ${latestVersion}"

echo "updating..."
updateVersion $latestVersion

updateHash $latestVersion
echo "updated cli"
