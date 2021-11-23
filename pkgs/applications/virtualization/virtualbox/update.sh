#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix-prefetch-scripts jq
# shellcheck shell=bash

set -xeuo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"

attr=virtualbox
oldVersion="$(nix-instantiate --eval -E "with import $nixpkgs {}; $attr.version or (builtins.parseDrvName $attr.name).version" | tr -d '"')"
latestVersion="$(curl -sS https://download.virtualbox.org/virtualbox/LATEST.TXT)"

function fileShaSum() {
  echo "$1" | grep -w $2 | cut -f1 -d' '
}
function oldHash() {
  nix-instantiate --eval --strict -A "$1.drvAttrs.outputHash" | tr -d '"'
}
function nixFile() {
  nix-instantiate --eval --strict -A "${1}.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/'
}

if [ ! "$oldVersion" = "$latestVersion" ]; then
  shaSums=$(curl -sS https://download.virtualbox.org/virtualbox/$latestVersion/SHA256SUMS)

  virtualBoxShaSum=$(fileShaSum "$shaSums" "VirtualBox-$latestVersion.tar.bz2")
  extpackShaSum=$(fileShaSum "$shaSums" "Oracle_VM_VirtualBox_Extension_Pack-$latestVersion.vbox-extpack")
  guestAdditionsShaSum=$(fileShaSum "$shaSums" "*VBoxGuestAdditions_$latestVersion.iso")

  virtualboxNixFile=$(nixFile ${attr})
  extpackNixFile=$(nixFile ${attr}Extpack)
  guestAdditionsNixFile=$(nixFile linuxPackages.${attr}GuestAdditions)

  extpackOldShaSum=$(oldHash ${attr}Extpack)
  guestAdditionsOldShaSum=$(oldHash linuxPackages.${attr}GuestAdditions.src)

  update-source-version $attr $latestVersion $virtualBoxShaSum
  sed -i -e 's|value = "'$extpackOldShaSum'"|value = "'$extpackShaSum'"|' $extpackNixFile
  sed -i -e 's|sha256 = "'$guestAdditionsOldShaSum'"|sha256 = "'$guestAdditionsShaSum'"|' $guestAdditionsNixFile

  git add $virtualboxNixFile $extpackNixFile $guestAdditionsNixFile
  git commit -m "$attr: ${oldVersion} -> ${latestVersion}"
else
  echo "$attr is already up-to-date"
fi
