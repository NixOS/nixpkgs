{ lib, stdenv, unzip, fetchurl, electron, makeWrapper, geogebra }:
let
  pname = "geogebra";
  version = "6-0-785-0";

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
        "https://web.archive.org/web/20230627211859/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
      hash = "sha256-Yv8pTCKkyM7XMUNV2Pcn/YxWo1MbOTNMQBFuJFhB/uE=";
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
        "https://web.archive.org/web/20230627214413/https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip"
      ];
      hash = "sha256-HtIhhq8E1Q5B6xZ7q6Ok95Rt53VWLoGf8PbY+UEOSKg=";
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
