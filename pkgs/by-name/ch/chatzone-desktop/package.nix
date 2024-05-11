{ lib
, appimageTools
, runCommand
, fetchurl
, stdenvNoCC
, makeDesktopItem
, copyDesktopItems
, makeWrapper
}:

let
  pname = "chatzone-desktop";
  version = "5.1.10";

  src = fetchurl {
    url = "https://cdn1.ozone.ru/s3/chatzone-clients/ci/20240129/254/chatzone-desktop-linux-5.1.10.AppImage";
    hash = "sha256-8jmJyg+Y2n8jGpWYnBRFsnCPIzoggJxG7neF7g6QQwk=";
  };

  appimage = appimageTools.wrapType2 {
    inherit pname version src;
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
  icon = runCommand "chatzone-app-icon.png" {} ''
    cp ${appimageContents}/app_icon.png $out
  '';
in stdenvNoCC.mkDerivation {
  inherit pname version;
  src = appimage;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      inherit icon;
      name = "chatzone";
      desktopName = "Chatzone";
      comment = "Ozon corporate messenger";
      exec = pname;
      categories = [ "Network" "InstantMessaging" "Chat" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

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
