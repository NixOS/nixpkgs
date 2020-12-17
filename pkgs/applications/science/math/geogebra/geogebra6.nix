{ stdenv, unzip, fetchurl, electron_6, makeWrapper, geogebra }:
let
  pname = "geogebra";
  version = "6-0-609-0";

  srcIcon = geogebra.srcIcon;
  desktopItem = geogebra.desktopItem;

  meta = with stdenv.lib; geogebra.meta // {
    license = licenses.geogebra;
    maintainers = with maintainers; [ voidless ];
    platforms = with platforms; linux ++ darwin;
  };

  linuxPkg = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      urls = [
          "https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
          "https://web.archive.org/web/20201022200156/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
        ];
      sha256 = "0rzcbq587x8827g9v03awa9hz27vyfjc0cz45ymbchqp31lsx49b";
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
      makeWrapper ${stdenv.lib.getBin electron_6}/bin/electron $out/bin/geogebra --add-flags "$out/resources/app"
      install -Dm644 "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      install -Dm644 "${srcIcon}" \
        "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
    '';
  };

  darwinPkg = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-${version}.zip";
      sha256 = "0275869zgwbl1qjj593q6629hnxbwk9c15rkm29a3lh10pinb099";
    };

    dontUnpack = true;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      install -dm755 $out/Applications
      unzip $src -d $out/Applications
    '';
  };
in
if stdenv.isDarwin
then darwinPkg
else linuxPkg
