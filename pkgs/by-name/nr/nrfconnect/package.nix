{ lib
, fetchurl
, appimageTools
}:

let
  pname = "nrfconnect";
  version = "4.3.0";

  src = fetchurl {
    url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-connect-for-desktop/${lib.versions.major version}-${lib.versions.minor version}-${lib.versions.patch version}/nrfconnect-${version}-x86_64.appimage";
    hash = "sha256-G8//dZqPxn6mR8Bjzf/bAn9Gv7t2AFWIF9twCGbqMd8=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    segger-jlink
  ];

  extraInstallCommands = ''
    mv $out/bin/nrfconnect-* $out/bin/nrfconnect
    install -Dm444 ${appimageContents}/nrfconnect.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nrfconnect.png \
      -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/nrfconnect.desktop \
      --replace 'Exec=AppRun' 'Exec=nrfconnect'
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF Connect for Desktop";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-desktop";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ stargate01 ];
    mainProgram = "nrfconnect";
  };
}
