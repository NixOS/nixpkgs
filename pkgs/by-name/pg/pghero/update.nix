{
  lib,
  writeShellScript,
  git,
  nix,
  bundler,
  bundix,
  coreutils,
  common-updater-scripts,
}:
writeShellScript "update-script" ''
  set -eu
  PATH=${
    lib.makeBinPath [
      git
      nix
      bundler
      bundix
      coreutils
      common-updater-scripts
    ]
  }
  nix() {
    command nix --extra-experimental-features nix-command "$@"
  }
  bundle() {
    BUNDLE_FORCE_RUBY_PLATFORM=1 command bundle "$@"
  }

  attrPath=''${UPDATE_NIX_ATTR_PATH:-pghero}

  toplevel=$(git rev-parse --show-toplevel)
  position=$(nix eval --file "$toplevel" --raw "$attrPath.meta.position")
  gemdir=$(dirname "$position")

  cd "$gemdir"

  tempdir=$(mktemp -d)
  cleanup() {
    rc=$?
    rm -r -- "$tempdir" || true
    exit $rc
  }
  trap cleanup EXIT

  cp gemset.nix "$tempdir"

  bundle lock --update --lockfile="$tempdir"/Gemfile.lock
  bundix --lockfile="$tempdir"/Gemfile.lock --gemset="$tempdir"/gemset.nix

  oldVersion=''${UPDATE_NIX_OLD_VERSION-}
  newVersion=$(nix eval --file "$tempdir"/gemset.nix --raw pghero.version)

  if [ "$oldVersion" = "$newVersion" ]; then
    exit
  fi

  cp "$tempdir"/{Gemfile.lock,gemset.nix} .

  cd "$toplevel"
  update-source-version "$attrPath" "$newVersion" --file="$gemdir"/package.nix --ignore-same-hash
''
