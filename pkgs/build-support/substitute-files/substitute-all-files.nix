{ stdenv }:

args:

stdenv.mkDerivation ({
  name = if args ? name then args.name else baseNameOf (toString args.src);
  builder = with stdenv.lib; builtins.toFile "builder.sh" ''
    source $stdenv/setup
    set -o pipefail

    eval "$preInstall"

    args=

    cd "$src"
    echo -ne "${concatStringsSep "\\0" args.files}" | xargs -0 -n1 -I {} -- find {} -type f -print0 | while read -d "" line; do
      mkdir -p "$out/$(dirname "$line")"
      substituteAll "$line" "$out/$line"
    done
  '';
  preferLocalBuild = true;
} // args)
