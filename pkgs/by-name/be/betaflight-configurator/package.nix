{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeDesktopItem,
  nwjs,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
}:

let
  pname = "betaflight-configurator";
  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "Betaflight configuration tool";
    desktopName = "Betaflight Configurator";
    genericName = "Flight controller configuration tool";
  };
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "10.10.0";
  src = fetchurl {
    url = "https://github.com/betaflight/${pname}/releases/download/${version}/${pname}_${version}_linux64-portable.zip";
    sha256 = "sha256-UB5Vr5wyCUZbOaQNckJQ1tAXwh8VSLNI1IgTiJzxV08=";
  };

  # remove large unneeded files
  postUnpack = ''
    find -name "lib*.so" -delete
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    unzip
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r . $out/opt/${pname}/
    install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    cp -r ${desktopItem}/share/applications $out/share/

    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/opt/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Betaflight flight control system configuration tool";
    mainProgram = "betaflight-configurator";
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/betaflight/betaflight/wiki";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
}
