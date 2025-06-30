#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set --o errexit -o noclobber -o nounset pipefail

latest_version=$(curl --location --silent https://gitlab.gnome.org/api/v4/projects/16742/releases/permalink/latest | jq --raw-output '.tag_name')
current_version=$(nix-instantiate --eval --expr "with import ./. {}; crosswords.version or (lib.getVersion crosswords)" --raw)

echo "Latest version: ${latest_version}"
echo "Current version: ${current_version}"

if [[ "${latest_version}" == "${current_version}" ]]; then
    echo "package is up-to-date"
    exit 0
fi

sha256=$(curl --location --silent "https://gitlab.gnome.org/jrb/crosswords/-/archive/${latest_version}/crosswords-${latest_version}.tar.gz.sha256sum")
sri=$(nix hash convert --to sri --hash-algo sha256 "${sha256}")
update-source-version crosswords "${latest_version}" "${sri}"
