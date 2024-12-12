#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq

# shellcheck disable=SC1008

set -eu -o pipefail

latestVersion=$(curl https://proton.me/download/mail/linux/version.json | jq -r 'first(.Releases[])|.Version')
downloadUrl="https://proton.me/download/mail/linux/${latestVersion}/ProtonMail-desktop-beta.deb"
latestSha=$(nix store prefetch-file "$downloadUrl" --json | jq -r '.hash')
update-source-version "protonmail-desktop" "$latestVersion" "$latestSha" --ignore-same-version --file=./pkgs/by-name/pr/protonmail-desktop/package.nix
