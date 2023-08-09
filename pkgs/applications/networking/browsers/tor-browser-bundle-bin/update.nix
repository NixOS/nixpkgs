{ lib
, writeShellScript
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, nix
, common-updater-scripts

# options
, pname
, version
, meta
, baseUrl ? "https://dist.torproject.org/torbrowser/"
# prefix used to match published archive
, prefix ? "tor-browser-"
# suffix used to match published archive
, suffix ? "_ALL.tar.xz"
}:

writeShellScript "update-${pname}" ''
  PATH="${lib.makeBinPath [ coreutils curl gnugrep gnused gnupg nix common-updater-scripts ]}"
  set -euo pipefail

  trap

  url=${baseUrl}
  version=$(curl -s $url \
            | sed -rne 's,^.*href="([0-9]+(\.[0-9]+)*)/".*,\1,p' \
            | sort --version-sort | tail -1)

  if [[ "${version}" = "$version" ]]; then
      echo "The new version same as the old version."
      exit 0
  fi

  HOME=$(mktemp -d)
  export GNUPGHOME=$(mktemp -d)
  trap 'rm -rf "$HOME" "$GNUPGHOME"' EXIT

  gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
  gpg --output $HOME/tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290

  curl --silent --show-error --fail -o $HOME/shasums "$url$version/sha256sums-signed-build.txt"
  curl --silent --show-error --fail -o $HOME/shasums.asc "$url$version/sha256sums-signed-build.txt.asc"
  gpgv --keyring=$HOME/tor.keyring $HOME/shasums.asc $HOME/shasums

  declare -A platforms=(
    ['x86_64-linux']='linux64'
    ['i686-linux']='linux32'
  )

  for platform in ${lib.escapeShellArgs meta.platforms}; do
    arch="''${platforms[$platform]}"
    sha256=$(cat "$HOME/shasums" | grep "${prefix}""$arch-$version""${suffix}" | cut -d" " -f1)
    hash=$(nix hash to-sri --type sha256 "$sha256")

    update-source-version "${pname}" "0" "sha256-${lib.fakeSha256}" --source-key="sources.$platform"
    update-source-version "${pname}" "$version" "$hash" --source-key="sources.$platform"
  done
''
