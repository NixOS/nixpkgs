{ lib
, makeDesktopItem
, copyDesktopItems
, stdenvNoCC
, fetchurl
, appimageTools
}:

let
  version = "1.8.4";
  pname = "session-desktop-appimage";

  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "Az9NEsqU4ZcmuSno38zflT4M4lI6/4ShEh3FVTcyRJg=";
  };
  appimage = appimageTools.wrapType2 {
    inherit version pname src;
  };
  appimage-contents = appimageTools.extractType2 {
    inherit version pname src;
  };
in
stdenvNoCC.mkDerivation {
  inherit version pname;
  src = appimage;

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "Session";
      desktopName = "Session";
      comment = "Onion routing based messenger";
      exec = "${appimage}/bin/session-desktop-appimage-${version}";
      icon = "${appimage-contents}/session-desktop.png";
      terminal = false;
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
