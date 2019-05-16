{ stdenv, fetchurl, unzip, makeWrapper, makeDesktopItem, icoutils, jre }:

let
  desktopItem = makeDesktopItem {
    name = "groove-simulator";
    exec = "groove-simulator";
    icon = "groove";
    desktopName = "GROOVE Simulator";
    comment = "GRaphs for Object-Oriented VErification";
    categories = "Science;ComputerScience;";
  };

in stdenv.mkDerivation rec {
  pname = "groove";
  version = "5.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/groove/groove/${version}/${pname}-${builtins.replaceStrings ["."] ["_"] version}-bin.zip";
    sha256 = "1cl3xzl3n8b9a7h5pvnv31bab9j9zaw07ppk8whk8h865dcq1d10";
  };

  nativeBuildInputs = [ unzip makeWrapper icoutils ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/groove
    cp -r bin lib $out/share/groove/

    mkdir -p $out/share/doc/groove
    cp CHANGES README *.pdf $out/share/doc/groove/

    mkdir -p $out/bin
    for bin in Generator Imager ModelChecker PrologChecker Simulator Viewer; do
      makeWrapper ${jre}/bin/java $out/bin/groove-''${bin,,} \
        --add-flags "-jar $out/share/groove/bin/$bin.jar"
    done

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons/hicolor/{16x16,32x32}/apps
    icotool -x -i 1 -o $out/share/icons/hicolor/32x32/apps/groove.png groove-green-g.ico
    icotool -x -i 2 -o $out/share/icons/hicolor/16x16/apps/groove.png groove-green-g.ico
  '';

  meta = with stdenv.lib; {
    description = "GRaphs for Object-Oriented VErification";
    homepage = http://groove.cs.utwente.nl/;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
