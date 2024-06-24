{ lib
, writeScript
, common-updater-scripts
, bash
, coreutils
, curl
, fetchurl
, gnugrep
, gnupg
, gnused
, nix
}:

let
  downloadPageUrl = "https://download.electrum.org";

  signingKeys = lib.lists.map fetchurl [
    {
      url = "https://github.com/spesmilo/electrum/raw/master/pubkeys/Emzy.asc";
      hash = "sha256-QG0cM6AKlSKFacVlhcso/xvrooUdF7oqoppyezt0hjE=";
    }
    {
      url = "https://github.com/spesmilo/electrum/raw/master/pubkeys/ThomasV.asc";
      hash = "sha256-37ApVZlI+2EevxQIKXVKVpktt1Ls3UbWq4dfio2ORdo=";
    }
    {
      url = "https://github.com/spesmilo/electrum/raw/master/pubkeys/sombernight_releasekey.asc";
      hash = "sha256-GgdPJ9TB5hh5SPCcTZURfqXkrU4qwl0dCci52V/wpdQ=";
    }
  ];

  gpgImportPaths = lib.concatStringsSep " " signingKeys;
in

writeScript "update-electrum" ''
#! ${bash}/bin/bash

set -eu -o pipefail

export PATH=${lib.makeBinPath [
  common-updater-scripts
  coreutils
  curl
  gnugrep
  gnupg
  gnused
  nix
]}

version=$(curl -L --list-only -- '${downloadPageUrl}' \
    | grep -Po '<a href="\K([[:digit:]]+\.?)+' \
    | sort -Vu \
    | tail -n1)

srcName=Electrum-$version
srcFile=$srcName.tar.gz
srcUrl="${downloadPageUrl}/$version/$srcFile"
sigUrl=$srcUrl.asc
sigFile=$srcFile.asc

[[ -e "$srcFile" ]] || curl -L -o "$srcFile" -- "$srcUrl"
[[ -e "$sigFile" ]] || curl -L -o "$sigFile" -- "$sigUrl"

export GNUPGHOME=$PWD/gnupg
mkdir -m 700 -p "$GNUPGHOME"

gpg --batch --import ${gpgImportPaths}
gpg --batch --verify "$sigFile" "$srcFile"

sha256=$(nix-prefetch-url --type sha256 "file://$PWD/$srcFile")

update-source-version electrum "$version" "$sha256"
''
