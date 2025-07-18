{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

let
  version = "1.15.2";
  pname = "session-desktop";

  src = fetchurl {
    url = "https://github.com/session-foundation/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    hash = "sha256-xQ/Fjg04XgXUioCCU0+sOLaTWZV1z05EmzZCqEU++Ok=";
  };
  appimage = appimageTools.wrapType2 { inherit version pname src; };
  appimage-contents = appimageTools.extractType2 { inherit version pname src; };
in
stdenvNoCC.mkDerivation {
  inherit version pname;
  src = appimage;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Session";
      desktopName = "Session";
      comment = "Onion routing based messenger";
      exec = "session-desktop";
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

    wrapProgram $out/bin/session-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Onion routing based messenger";
    mainProgram = "session-desktop";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      alexnortung
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
