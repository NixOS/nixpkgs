{
  lib,
  stdenv,
  unzip,
  fetchurl,
  electron,
  makeWrapper,
  geogebra,
}:
let
  pname = "geogebra";
  version = "6-0-804-0";

  srcIcon = geogebra.srcIcon;
  desktopItem = geogebra.desktopItem;

  meta = {
    description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
    longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
    '';
    homepage = "https://www.geogebra.org/";
    maintainers = with lib.maintainers; [
      voidless
      sikmir
    ];
    license = lib.licenses.geogebra;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode # some jars include native binaries
    ];
    platforms = with lib.platforms; linux ++ darwin;
    hydraPlatforms = [ ];
  };

  linuxPkg = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
      hash = "sha256-EU5Tf62TIuGujr34qnNORzs8Zqnx2YxaHsX6Vdbqm9c=";
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
      makeWrapper ${lib.getBin electron}/bin/electron $out/bin/geogebra \
        --add-flags "$out/resources/app" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -Dm644 "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

      install -Dm644 "${srcIcon}" \
        "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
    '';
  };

  darwinPkg = stdenv.mkDerivation {
    inherit pname;

    src = fetchurl {
      urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Classic-6-MacOS-Portable-6-0-915-1.zip" # No old version. Should be separated from here. (Added and calculated hash for compatibility)
      ];
      hash = "sha256-wp+MSUsleizqMnXuv7l0i420JYcGoKR5GwOVG7MDiOw=";
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
if stdenv.hostPlatform.isDarwin then darwinPkg else linuxPkg
