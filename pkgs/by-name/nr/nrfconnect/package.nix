{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  segger-jlink-headless,
}:

let
  pname = "nrfconnect";
  version = "5.3.1";

  src = fetchurl {
    url = "https://eu.files.nordicsemi.com/ui/api/v1/download?repoKey=web-assets-com_nordicsemi&path=external%2fswtools%2fncd%2flauncher%2fv${version}%2fnrfconnect-${version}-x86_64.AppImage";
    hash = "sha256-IRpY8D9jigQjWvBVEfFshqTV4h9/6OaJf9T178B2m/c=";
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
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/nrfconnect.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nrfconnect.png \
      -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/nrfconnect.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=nrfconnect'
  '';

  meta = {
    description = "Nordic Semiconductor nRF Connect for Desktop";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-desktop";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ stargate01 ];
    mainProgram = "nrfconnect";
  };
}
