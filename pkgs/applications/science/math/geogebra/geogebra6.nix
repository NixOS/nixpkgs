{ lib, stdenv, unzip, fetchurl, electron, makeWrapper, geogebra }:
let
  pname = "geogebra";
  version = "6-0-676-0";

  srcIcon = geogebra.srcIcon;
  desktopItem = geogebra.desktopItem;

  meta = with lib; geogebra.meta // {
    license = licenses.geogebra;
    maintainers = with maintainers; [ voidless sikmir ];
    platforms = with platforms; linux ++ darwin;
  };

  linuxPkg = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
        "https://web.archive.org/web/20211123222708/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
      sha256 = "0wn90n2nd476rkf83gk9vvcpbjflkrvyri50pnmv52j76n023hmm";
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
        "https://web.archive.org/web/20211124143625/https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip"
      ];
      sha256 = "1dwv2f94a1c2y10lmy0i66cafynalp7dkqgnpk4f0mk6pir2fdgj";
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
