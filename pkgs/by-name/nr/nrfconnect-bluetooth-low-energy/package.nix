{
  lib,
  fetchurl,
  appimageTools,
  segger-jlink-headless,
  libxshmfence,
}:

let
  pname = "nrfconnect-bluetooth-low-energy";
  version = "4.0.4";

  src = fetchurl {
    url = "https://github.com/NordicPlayground/pc-nrfconnect-ble-standalone/releases/download/v${version}/nrfconnect-bluetooth-low-energy-${version}-x86_64.AppImage";
    hash = "sha256-mL8ky/cYjNgfUJgE7W5LFK/w7Ky9Xx6E84UT668HRAk=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    segger-jlink-headless
    libxshmfence
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/nrfconnect-bluetooth-low-energy.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nrfconnect-bluetooth-low-energy.png \
      -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/nrfconnect-bluetooth-low-energy.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=nrfconnect-bluetooth-low-energy'
  '';

  meta = {
    description = "Nordic Semiconductor Bluetooth low energy app for nRF Connect for Desktop";
    homepage = "https://docs.nordicsemi.com/bundle/nrf-connect-ble/page/index.html";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ stargate01 ];
    mainProgram = "nrfconnect-bluetooth-low-energy";
  };
}
