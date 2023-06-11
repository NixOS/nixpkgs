{ writeScript
, lib
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, jq
, nix
, nix-prefetch-git
, moreutils
, runtimeShell
, ...
}:

writeScript "update-librewolf" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ coreutils curl gnugrep gnupg gnused jq moreutils nix nix-prefetch-git  ]}
  set -euo pipefail

  latestTag=$(curl https://gitlab.com/api/v4/projects/librewolf-community%2Fbrowser%2Fsource/repository/tags?per_page=1 | jq -r .[0].name)
  echo "latestTag=$latestTag"

  srcJson=pkgs/applications/networking/browsers/librewolf/src.json
  localRev=$(jq -r .source.rev < $srcJson)
  echo "localRev=$localRev"

  if [ "$localRev" == "$latestTag" ]; then
    exit 0
  fi

  prefetchOut=$(mktemp)
  repoUrl=https://gitlab.com/librewolf-community/browser/source.git/
  nix-prefetch-git $repoUrl --quiet --rev $latestTag --fetch-submodules > $prefetchOut
  srcDir=$(jq -r .path < $prefetchOut)
  srcHash=$(jq -r .sha256 < $prefetchOut)

  ffVersion=$(<$srcDir/version)
  lwRelease=$(<$srcDir/release)
  lwVersion="$ffVersion-$lwRelease"
  echo "lwVersion=$lwVersion"
  echo "ffVersion=$ffVersion"
  if [ "$lwVersion" != "$latestTag" ]; then
    echo "error: Tag name does not match the computed LibreWolf version"
    exit 1
  fi

  macosAssets=$(curl https://gitlab.com/api/v4/projects/librewolf-community%2Fbrowser%2Fmacos/releases/v$latestTag/assets/links)
  x86_64url=$(jq --raw-output --arg name librewolf-$latestTag.en-US.mac.x86_64.dmg '.[] | select(.name==$name) | .url' <<< "$macosAssets")
  x86_64hash=$(nix-prefetch-url --type sha256 $x86_64url)
  aarch64url=$(jq --raw-output --arg name librewolf-$latestTag.en-US.mac.aarch64.dmg '.[] | select(.name==$name) | .url' <<< "$macosAssets")
  aarch64hash=$(nix-prefetch-url --type sha256 $aarch64url)


  HOME=$(mktemp -d)
  export GNUPGHOME=$(mktemp -d)
  gpg --receive-keys 14F26682D0916CDD81E37B6D61B7B526D98F0353

  mozillaUrl=https://archive.mozilla.org/pub/firefox/releases/

  curl --silent --show-error -o "$HOME"/shasums "$mozillaUrl$ffVersion/SHA512SUMS"
  curl --silent --show-error -o "$HOME"/shasums.asc "$mozillaUrl$ffVersion/SHA512SUMS.asc"
  gpgv --keyring="$GNUPGHOME"/pubring.kbx "$HOME"/shasums.asc "$HOME"/shasums

  ffHash=$(grep '\.source\.tar\.xz$' "$HOME"/shasums | grep '^[^ ]*' -o)
  echo "ffHash=$ffHash"

  jq ".source.rev = \"$latestTag\"" $srcJson | sponge $srcJson
  jq ".source.sha256 = \"$srcHash\"" $srcJson | sponge $srcJson
  jq ".bin.mac.x86_64.url = \"$x86_64url\"" $srcJson | sponge $srcJson
  jq ".bin.mac.x86_64.sha256 = \"$x86_64hash\"" $srcJson | sponge $srcJson
  jq ".bin.mac.aarch64.url = \"$aarch64url\"" $srcJson | sponge $srcJson
  jq ".bin.mac.aarch64.sha256 = \"$aarch64hash\"" $srcJson | sponge $srcJson
  jq ".firefox.version = \"$ffVersion\"" $srcJson | sponge $srcJson
  jq ".firefox.sha512 = \"$ffHash\"" $srcJson | sponge $srcJson
  jq ".packageVersion = \"$lwVersion\"" $srcJson | sponge $srcJson
''
