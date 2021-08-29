{ lib
, inkscape
, symlinkJoin
, makeWrapper
, inkscapeExtensions ? []
}:

symlinkJoin {
  name = "inkscape-with-extensions-${lib.getVersion inkscape}";

  paths = [ inkscape ] ++ inkscapeExtensions;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    rm -f $out/bin/inkscape
    makeWrapper "${inkscape}/bin/inkscape" "$out/bin/inkscape" --set INKSCAPE_DATADIR "$out/share"
  '';

  inherit (inkscape) meta;
}
