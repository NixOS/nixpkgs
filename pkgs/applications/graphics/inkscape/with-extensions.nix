{
  lib,
  inkscape,
  symlinkJoin,
  makeWrapper,
  inkscapeExtensions ? [ ],
  inkscape-extensions,
}:

let
  allExtensions = lib.filter (pkg: lib.isDerivation pkg && !pkg.meta.broken or false) (
    lib.attrValues inkscape-extensions
  );
  selectedExtensions = if inkscapeExtensions == null then allExtensions else inkscapeExtensions;
in

symlinkJoin {
  name = "inkscape-with-extensions-${lib.getVersion inkscape}";

  paths = [ inkscape ] ++ selectedExtensions;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    rm -f $out/bin/inkscape
    makeWrapper "${inkscape}/bin/inkscape" "$out/bin/inkscape" --set INKSCAPE_DATADIR "$out/share"
  '';

  inherit (inkscape) meta;
}
