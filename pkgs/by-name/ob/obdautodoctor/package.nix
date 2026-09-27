{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  kdePackages,
  bluez,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obdautodoctor";
  version = "5.1.8";

  src = fetchzip {
    url = "https://cdn2.obdautodoctor.com/release/obd-auto-doctor_${finalAttrs.version}_amd64.tar.gz";
    hash = "sha256-3qht1G2Qi+IhL/x9MMEAwM0exCav5iKtnZXTl6cwx3E=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    kdePackages.qtbase
    bluez
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    kdePackages.wrapQtAppsHook
    copyDesktopItems
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D obdautodoctor $out/bin/obdautodoctor
    install -D obdautodoctor.png $out/share/icons/hicolor/128x128/apps/obdautodoctor.png

    install -D license.txt $out/share/licenses/obdautodoctor/license.txt
    install -D lgpl-3.0.txt $out/share/licenses/obdautodoctor/lgpl-3.0.txt

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "obdautodoctor";
      desktopName = "OBD Auto Doctor";
      comment = "OBD Car Diagnostics Software";
      icon = "obdautodoctor";
      exec = "obdautodoctor";
      terminal = false;
      categories = [
        "Qt"
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Diagnose problems, reset the Check Engine Light, and monitor your car's performance with ease";
    homepage = "https://www.obdautodoctor.com/";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ leoflo ];
  };
})
