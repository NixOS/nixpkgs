{lib, stdenv, fetchurl, unzip, makeDesktopItem, copyDesktopItems, nwjs084, wrapGAppsHook3, gsettings-desktop-schemas, gtk3, version, sha256 }:

let
  shortVersion = lib.versions.majorMinor version;
  pname = "betaflight-configurator-" + shortVersion;
in
stdenv.mkDerivation rec {
  inherit pname;
  inherit version;

  src = fetchurl {
    url = "https://github.com/betaflight/betaflight-configurator/releases/download/${version}/betaflight-configurator_${version}_linux64-portable.zip";
    inherit sha256;
  };

  # remove large unneeded files
  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 unzip ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r . $out/opt/${pname}/
    install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${pname}.png

    makeWrapper ${nwjs084}/bin/nw $out/bin/${pname} --add-flags $out/opt/${pname}
    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "Betaflight configuration tool " + version;
    desktopName = "Betaflight Configurator " + version;
    genericName = "Flight controller configuration tool";
  };
  meta = {
    description = "The Betaflight flight control system configuration tool";
    mainProgram = pname;
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage    = "https://github.com/betaflight/betaflight/wiki";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license     = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wucke13 ilya-epifanov ];
    platforms   = lib.platforms.linux;
  };
}
