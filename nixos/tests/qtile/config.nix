{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation {
  name = "qtile-config";
  version = "0.0.1";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/qtile/qtile/v0.28.1/libqtile/resources/default_config.py";
    hash = "sha256-Y5W277CWVNSi4BdgEW/f7Px/MMjnN9W9TDqdOncVwPc=";
  };

  prePatch = ''
    cp $src config.py
  '';

  patches = [ ./add-widget.patch ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp config.py $out/config.py
  '';
}
