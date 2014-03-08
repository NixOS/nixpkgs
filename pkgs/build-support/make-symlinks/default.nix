{ pkgs, stdenv, name ? "", path ? "", files}:
  with pkgs.lib;
stdenv.mkDerivation {
  inherit name;
  inherit path;

  builder = ./builder.sh;

  preferLocalBuild = true;

  /* !!! Use toXML. */
  sources = map (x: if isDerivation x then x else x.source) files;
  targets = map (x: if isDerivation x then x.name else
                      (if hasAttr "target" x then x.target else x.source.name)) files;
  modes = map (x: if !isDerivation x && hasAttr "mode" x then x.mode else "symlink") files;
}
