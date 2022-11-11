{ lib
, makeDesktopItem
, copyDesktopItems
, stdenvNoCC
, fetchurl
, appimageTools
, makeWrapper
}:

let
  version = "1.10.3";
  pname = "session-desktop";

  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "sha256-I9YyzfI8EqH8LZe5E5BnD9lGPAdQo++l3yRClfN7+pY=";
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

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      name = "Session";
      desktopName = "Session";
      comment = "Onion routing based messenger";
      exec = "${appimage}/bin/session-desktop-${version}";
      icon = "${appimage-contents}/session-desktop.png";
      terminal = false;
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mv bin/session-desktop-${version} bin/session-desktop

    mkdir -p $out/
    cp -r bin $out/bin

    wrapProgram $out/bin/session-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

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
