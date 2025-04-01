{ lib, stdenv }:

args:

stdenv.mkDerivation (
  {
    name = if args ? name then args.name else baseNameOf (toString args.src);
    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      set -o pipefail

      eval "$preInstall"

      args=

      pushd "$src"
      echo -ne "${lib.concatStringsSep "\\0" args.files}" | xargs -0 -n1 -I {} -- find {} -type f -print0 | while read -d "" line; do
        mkdir -p "$out/$(dirname "$line")"
        substituteAll "$line" "$out/$line"
      done
      popd

      eval "$postInstall"
    '';
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  // args
)
