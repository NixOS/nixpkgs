{
  lib,
  fetchurl,
  appimageTools,
  electron,
  stdenvNoCC,
  makeDesktopItem,
  copyDesktopItems,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chatzone-desktop";
  version = "5.6.2";

  src = appimageTools.extract {
    inherit (finalAttrs) pname version;
    src = fetchurl {
      url = "https://ir.ozone.ru/s3/chatzone-clients/ci/5.6.2/1175/chatzone-desktop-linux-5.6.2.AppImage";
      hash = "sha256-2t3mp0snHn2NxVFCcU1XQ5h3rUCb4gXjKbF43p9W8ZU=";
    };
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
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

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/chatzone-desktop" "$out/bin"

    cp -r --no-preserve=mode resources "$out/opt/chatzone-desktop/"

    cp -r --no-preserve=mode usr/share/icons "$out/share"

    makeWrapper "${electron}/bin/electron" "$out/bin/chatzone-desktop" \
      --add-flags "$out/opt/chatzone-desktop/resources/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0

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
})
