{ lib
, writeScript
, common-updater-scripts
, bash
, coreutils
, curl
, gnugrep
, gnupg
, gnused
, nix
}:

let
  downloadPageUrl = "https://download.electrum.org";

  signingKeys = ["6694 D8DE 7BE8 EE56 31BE D950 2BD5 824B 7F94 70E6"];
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

gpg --batch --recv-keys ${lib.concatStringsSep " " (map (x: "'${x}'") signingKeys)}
gpg --batch --verify "$sigFile" "$srcFile"

sha256=$(nix-prefetch-url --type sha256 "file://$PWD/$srcFile")

update-source-version electrum "$version" "$sha256"
''
