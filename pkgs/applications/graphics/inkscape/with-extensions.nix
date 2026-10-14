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
  inherit (inkscape) version;
  pname = "inkscape-with-extensions";

  outputs = [
    "out"
    "man"
  ];

  paths = [ inkscape ] ++ selectedExtensions;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    rm -f $out/bin/inkscape
    makeWrapper "${inkscape}/bin/inkscape" "$out/bin/inkscape" --set INKSCAPE_DATADIR "$out/share"

    ln -s ${inkscape.man} $man
  '';

  inherit (inkscape) meta;
}
