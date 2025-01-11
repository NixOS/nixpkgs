{
  lib,
  appimageTools,
  fetchurl,
  stdenvNoCC,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
}:

let
  pname = "chatzone-desktop";
  version = "5.2.3";
  src = fetchurl {
    url = "https://cdn1.ozone.ru/s3/chatzone-clients/ci/5.2.3/466/chatzone-desktop-linux-5.2.3.AppImage";
    hash = "sha256-/1xAMtw1SgYge4b9RngBFQjb+rOUkvOalZPC+GtnvSA=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimageTools.wrapType2 { inherit pname version src; };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "chatzone";
      exec = "chatzone-desktop";
      icon = "chatzone-desktop";
      terminal = false;
      desktopName = "Chatzone";
      genericName = "Ozon corporate messenger";
      comment = "Mattermost Desktop application for Linux";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/mattermost" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/chatzone-desktop/
    cp ${appimageContents}/app_icon.png $out/share/chatzone-desktop/
    cp -r ${appimageContents}/usr/share/icons $out/share

    wrapProgram $out/bin/chatzone-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  meta = {
    description = "Ozon corporate messenger";
    mainProgram = "chatzone-desktop";
    homepage = "https://apps.o3team.ru/";
    downloadPage = "https://apps.o3team.ru/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    platforms = [ "x86_64-linux" ];
  };
}
