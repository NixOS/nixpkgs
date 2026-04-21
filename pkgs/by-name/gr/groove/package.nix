{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  icoutils,
  jre8,
}:
stdenv.mkDerivation rec {
  pname = "groove";
  version = "5.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/groove/groove/${version}/groove-${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }-bin.zip";
    sha256 = "sha256-JwoUlO6F2+8NtCnLC+xm5q0Jm8RIyU1rnuKGmjgJhFU=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    unzip
    makeWrapper
    icoutils
  ];

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "groove-simulator";
      exec = "groove-simulator";
      icon = "groove";
      desktopName = "GROOVE Simulator";
      comment = "GRaphs for Object-Oriented VErification";
      categories = [
        "Science"
        "ComputerScience"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/groove
    cp -r bin lib $out/share/groove/

    mkdir -p $out/share/doc/groove
    cp CHANGES README *.pdf $out/share/doc/groove/

    mkdir -p $out/bin
    for bin in Generator Imager ModelChecker PrologChecker Simulator Viewer; do
      makeWrapper ${jre8}/bin/java $out/bin/groove-''${bin,,} \
        --add-flags "-jar $out/share/groove/bin/$bin.jar"
    done

    mkdir -p $out/share/icons/hicolor/{16x16,32x32}/apps
    icotool -x -i 1 -o $out/share/icons/hicolor/32x32/apps/groove.png groove-green-g.ico
    icotool -x -i 2 -o $out/share/icons/hicolor/16x16/apps/groove.png groove-green-g.ico

    runHook postInstall
  '';

  meta = {
    description = "GRaphs for Object-Oriented VErification";
    homepage = "https://groove.cs.utwente.nl/";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
