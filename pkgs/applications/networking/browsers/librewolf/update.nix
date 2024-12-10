{ writeScript
, lib
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, jq
, nix-prefetch-git
, moreutils
, runtimeShell
, ...
}:

writeScript "update-librewolf" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ coreutils curl gnugrep gnupg gnused jq moreutils nix-prefetch-git ]}
  set -euo pipefail

  latestTag=$(curl "https://codeberg.org/api/v1/repos/librewolf/source/tags?page=1&limit=1" | jq -r .[0].name)
  echo "latestTag=$latestTag"

  srcJson=pkgs/applications/networking/browsers/librewolf/src.json
  localRev=$(jq -r .source.rev < $srcJson)
  echo "localRev=$localRev"

  if [ "$localRev" == "$latestTag" ]; then
    exit 0
  fi

  prefetchOut=$(mktemp)
  repoUrl=https://codeberg.org/librewolf/source.git
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
  jq ".firefox.version = \"$ffVersion\"" $srcJson | sponge $srcJson
  jq ".firefox.sha512 = \"$ffHash\"" $srcJson | sponge $srcJson
  jq ".packageVersion = \"$lwVersion\"" $srcJson | sponge $srcJson
''
