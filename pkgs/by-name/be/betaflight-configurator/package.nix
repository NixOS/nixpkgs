{
  lib,
  stdenv,
  fetchzip,
  makeDesktopItem,
  wrapGAppsHook3,
  copyDesktopItems,
  nwjs,
  gsettings-desktop-schemas,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "betaflight-configurator";
  version = "10.10.0";
  src = fetchzip {
    url = "https://github.com/betaflight/betaflight-configurator/releases/download/${finalAttrs.version}/betaflight-configurator_${finalAttrs.version}_linux64-portable.zip";
    hash = "sha256-UB5Vr5wyCUZbOaQNckJQ1tAXwh8VSLNI1IgTiJzxV08=";

    # remove large unneeded files
    postUnpack = ''
      find -name "lib*.so" -delete
    '';
  };

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.pname;
      comment = "Betaflight configuration tool";
      desktopName = "Betaflight Configurator";
      genericName = "Flight controller configuration tool";
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    nwjs
  ];

  installPhase = ''
    runHook preInstall

    # install files
    mkdir -p $out/opt/${finalAttrs.pname}
    cp -r . $out/opt/${finalAttrs.pname}

    # install icon
    install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${finalAttrs.pname}.png

    # create binary
    mkdir -p $out/bin
    makeWrapper ${lib.getExe' nwjs "nw"} $out/bin/${finalAttrs.meta.mainProgram} --add-flags $out/opt/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = {
    description = "Betaflight flight control system configuration tool";
    mainProgram = "betaflight-configurator";
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/betaflight/betaflight/wiki";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.linux;
  };
})
