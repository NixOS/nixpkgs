{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:

let
  pname = "fluxer-bin";
  version = "0.0.8";

  src = fetchurl {
    url = "https://api.fluxer.app/dl/desktop/stable/linux/x64/fluxer-stable-${version}-x86_64.AppImage";
    hash = "sha256-GdoBK+Z/d2quEIY8INM4IQy5tzzIBBM+3CgJXQn0qAw=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "fluxer";
    desktopName = "Fluxer";
    comment = "Fluxer desktop client";
    exec = "fluxer-bin %U";
    icon = "fluxer";
    terminal = false;
    categories = [ "InstantMessaging" ];
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/*.desktop \
      $out/share/applications/fluxer.desktop

    install -Dm444 \
      ${appimageContents}/usr/share/icons/hicolor/256x256/apps/fluxer.png \
      $out/share/icons/hicolor/256x256/apps/fluxer.png
  '';

  meta = {
    description = "Fluxer desktop client";
    homepage = "https://fluxer.app";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "fluxer-bin";
    maintainers = with lib.maintainers; [ WoutFontaine ];
  };
}
