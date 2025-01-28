#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix-prefetch-scripts jq

set -xeuo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"

attr=virtualbox
oldVersion="$(nix-instantiate --eval -E "with import $nixpkgs {}; $attr.version or (builtins.parseDrvName $attr.name).version" | tr -d '"')"
latestVersion="$(curl -sS https://download.virtualbox.org/virtualbox/LATEST.TXT)"

function fileShaSum() {
  echo "$1" | grep -w "$2" | cut -f1 -d' '
}
function oldHash() {
  nix-instantiate --eval --strict -A "$1.drvAttrs.outputHash" | tr -d '"'
}
function nixFile() {
  nix-instantiate --eval --strict -A "${1}.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/'
}

if [ ! "$oldVersion" = "$latestVersion" ]; then
  shaSums=$(curl -sS "https://download.virtualbox.org/virtualbox/$latestVersion/SHA256SUMS")

  virtualBoxShaSum=$(fileShaSum "$shaSums" "VirtualBox-$latestVersion.tar.bz2")
  extpackShaSum=$(fileShaSum "$shaSums" "Oracle_VirtualBox_Extension_Pack-$latestVersion.vbox-extpack")
  guestAdditionsIsoShaSum=$(fileShaSum "$shaSums" "*VBoxGuestAdditions_$latestVersion.iso")

  virtualboxNixFile=$(nixFile ${attr})
  extpackNixFile=$(nixFile ${attr}Extpack)
  guestAdditionsIsoNixFile="pkgs/applications/virtualization/virtualbox/guest-additions-iso/default.nix"
  virtualboxGuestAdditionsNixFile="pkgs/applications/virtualization/virtualbox/guest-additions/default.nix"

  virtualBoxOldShaSum=$(oldHash ${attr}Extpack)
  extpackOldShaSum=$(oldHash ${attr}Extpack)

  sed -e "s/virtualboxVersion = \".*\";/virtualboxVersion = \"$latestVersion\";/g" \
      -e "s/virtualboxSubVersion = \".*\";/virtualboxSubVersion = \"\";/g" \
      -e "s/virtualboxSha256 = \".*\";/virtualboxSha256 = \"$virtualBoxShaSum\";/g" \
      -i "$virtualboxNixFile"
  sed -e 's|value = "'$extpackOldShaSum'"|value = "'$extpackShaSum'"|' \
      -e "s/virtualboxExtPackVersion = \".*\";/virtualboxExtPackVersion = \"$latestVersion\";/g" \
      -i $extpackNixFile
  sed -e "s/sha256 = \".*\";/sha256 = \"$guestAdditionsIsoShaSum\";/g" \
      -i "$guestAdditionsIsoNixFile"
  sed -e "s/virtualboxVersion = \".*\";/virtualboxVersion = \"$latestVersion\";/g" \
      -e "s/virtualboxSubVersion = \".*\";/virtualboxSubVersion = \"\";/g" \
      -e "s/virtualboxSha256 = \".*\";/virtualboxSha256 = \"$virtualBoxShaSum\";/g" \
      -i "$virtualboxGuestAdditionsNixFile"

  git add "$virtualboxNixFile" "$extpackNixFile" "$guestAdditionsIsoNixFile" "$virtualboxGuestAdditionsNixFile"
  git commit -m "$attr: ${oldVersion} -> ${latestVersion}"
else
  echo "$attr is already up-to-date"
fi
