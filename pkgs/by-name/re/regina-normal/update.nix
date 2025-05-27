{
  lib,
  writeShellScript,
  coreutils,
  findutils,
  curl,
  gnupg,
  gawk,
  jq,
  nix,
  common-updater-scripts,

  attrPath ? "regina-normal",
  url ? "https://api.github.com/repos/regina-normal/regina/releases/latest",
}:

writeShellScript "update-${attrPath}" ''
  PATH="${
    lib.makeBinPath [
      coreutils
      findutils
      curl
      gnupg
      jq
      gawk
      nix
      common-updater-scripts
    ]
  }"
  set -euo pipefail

  old_version=$1
  tag_name=$(curl --silent --show-error ${url} | jq -r '.tag_name')
  version=''${tag_name#regina-}

  if [[ "$version" = "$old_version" ]]; then
      echo "New version same as old version, nothing to do." >&2
      exit 0
  fi

  manifest_url=https://github.com/regina-normal/regina/releases/download/regina-$version/SHA256SUMS-signed.txt

  HOME=$(mktemp -d)
  export GNUPGHOME=$(mktemp -d)

  curl --silent --show-error -o "$HOME/manifest.txt" -L "$manifest_url"
  gpg --keyserver hkps://keyring.debian.org:443 --recv-keys 0x70A6BEDF542D38D9 2>/dev/null # Public key for Benjamin Burton <bab@debian.org>
  gpg --trust-model always --verify "$HOME/manifest.txt"

  hash=$(gpg --decrypt "$HOME/manifest.txt" 2>/dev/null \
         | awk '$2=="regina-" ENVIRON["version"] ".tar.gz" {print $1}' \
         | xargs nix-hash --type sha256 --to-sri)

  update-source-version ${attrPath} "$version" "$hash"
''
