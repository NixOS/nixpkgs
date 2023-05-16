{ lib, stdenv, unzip, fetchurl, electron, makeWrapper, geogebra }:
let
  pname = "geogebra";
<<<<<<< HEAD
  version = "6-0-794-0";
=======
  version = "6-0-745-0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  srcIcon = geogebra.srcIcon;
  desktopItem = geogebra.desktopItem;

  meta = with lib; {
    description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
    longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
    '';
    homepage = "https://www.geogebra.org/";
    maintainers = with maintainers; [ voidless sikmir ];
    license = licenses.geogebra;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode  # some jars include native binaries
    ];
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
  };

  linuxPkg = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
<<<<<<< HEAD
        "https://web.archive.org/web/20230824011801/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
      hash = "sha256-sNCq1Xcx/Y5r+SIRiqQYcG9dVsfIC2Ef5KJf+tgfxC8=";
=======
        "https://web.archive.org/web/20221126110648/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
      hash = "sha256-UksHZt7bEs/aRzFiJrT1Quz/SFSvA88sdhoi1IEVdBc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/libexec/geogebra/ $out/bin
      cp -r GeoGebra-linux-x64/{resources,locales} "$out/"
      makeWrapper ${lib.getBin electron}/bin/electron $out/bin/geogebra --add-flags "$out/resources/app"
      install -Dm644 "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      install -Dm644 "${srcIcon}" \
        "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
    '';
  };

  darwinPkg = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip"
<<<<<<< HEAD
        "https://web.archive.org/web/20230824012900/https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip"
      ];
      hash = "sha256-CrSoKAjXiejfJHyv8wIpcRr2d8u/50HnatiDm1CdnGQ=";
=======
        "https://web.archive.org/web/20221126111123/https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip"
      ];
      hash = "sha256-Qn2MD3W5icX45Tfs19oRV8J3lYmL8T+hp7A+crRb9tQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    dontUnpack = true;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      install -dm755 $out/Applications
      unzip $src -d $out/Applications
    '';

    meta = meta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
if stdenv.isDarwin
then darwinPkg
else linuxPkg
