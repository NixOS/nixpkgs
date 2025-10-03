#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils jq

# shellcheck disable=SC1008

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

latestVersion=$(curl https://proton.me/download/mail/linux/version.json | jq -r 'first(.Releases[])|.Version')
linuxDownloadUrl="https://proton.me/download/mail/linux/${latestVersion}/ProtonMail-desktop-beta.deb"
darwinDownloadUrl="https://proton.me/download/mail/macos/${latestVersion}/ProtonMail-desktop.dmg"

latestLinuxSha=$(nix store prefetch-file "$linuxDownloadUrl" --json | jq -r '.hash')
latestDarwinSha=$(nix store prefetch-file "$darwinDownloadUrl" --json | jq -r '.hash')

sed -i "s|version = \".*\";|version = \"${latestVersion}\";|" ./package.nix
sed -i "s|linuxHash = \"sha256-[^\"]*\";|linuxHash = \"${latestLinuxSha}\";|" ./package.nix
sed -i "s|darwinHash = \"sha256-[^\"]*\";|darwinHash = \"${latestDarwinSha}\";|" ./package.nix
