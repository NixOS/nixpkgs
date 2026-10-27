{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeDesktopItem,
  copyDesktopItems,
  nwjs,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "betaflight-configurator";
  version = "10.10.0";
  src = fetchurl {
    url = "https://github.com/betaflight/${finalAttrs.pname}/releases/download/${finalAttrs.version}/${finalAttrs.pname}_${finalAttrs.version}_linux64-portable.zip";
    sha256 = "sha256-UB5Vr5wyCUZbOaQNckJQ1tAXwh8VSLNI1IgTiJzxV08=";
  };

  # remove large unneeded files
  postUnpack = ''
    find -name "lib*.so" -delete
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    unzip
    copyDesktopItems
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = finalAttrs.pname;
      comment = "Betaflight configuration tool";
      desktopName = "Betaflight Configurator";
      genericName = "Flight controller configuration tool";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin \
             $out/opt/${finalAttrs.pname}

    cp -r . $out/opt/${finalAttrs.pname}/
    install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${finalAttrs.pname}.png

    makeWrapper ${nwjs}/bin/nw $out/bin/${finalAttrs.pname} --add-flags $out/opt/${finalAttrs.pname}
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
