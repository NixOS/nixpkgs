{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "chatzone-desktop";
  version = "5.7.0";

  src = fetchurl {
    url = "https://ir.ozone.ru/s3/chatzone-clients/ci/5.7.0/1258/chatzone-desktop-linux-5.7.0.AppImage";
    hash = "sha256-t8qAdrvs1M9NuaQYZj+pCaYiSb4TZc7rY1rJVjSYaAE=";
  };

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
      comment = "Chatzone Desktop application for Linux";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      startupWMClass = "Chatzone";
      mimeTypes = [ "x-scheme-handler/mattermost" ];
    })
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/chatzone-desktop/
    cp ${finalAttrs.contents}/app_icon.png $out/share/chatzone-desktop/
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    wrapProgram $out/bin/chatzone-desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
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
})
