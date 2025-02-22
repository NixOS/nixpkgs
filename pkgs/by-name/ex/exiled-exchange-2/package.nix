{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}: let
  version = "0.7.1";
  pname = "exiled-exchange-2";

  src = fetchurl {
    url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v${version}/Exiled-Exchange-2-${version}.AppImage";
    sha256 = "07c1jvyfvd55f6wkvyma8wmwbskfmnk4h8qxy42xhrbq0wbx6yb5";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "exiled-exchange-2";
    exec = "exiled-exchange-2";
    icon = "exiled-exchange-2";
    type = "Application";
    comment = "Path of Exile 2 overlay program for price checking items, among many other loved features.";
    desktopName = "Exiled Exchange 2";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${desktopItem}/share/applications/exiled-exchange-2.desktop $out/share/applications/exiled-exchange-2.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/exiled-exchange-2.png \
         $out/share/icons/hicolor/512x512/apps/exiled-exchange-2.png
    '';

    meta = {
      mainProgram = "exiled-exchange-2";
      description = "Path of Exile 2 overlay program for price checking items, among many other loved features.";
      homepage = "https://github.com/Kvan7/Exiled-Exchange-2";
      downloadPage = "https://github.com/Kvan7/Exiled-Exchange-2/releases";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [guno327];
      platforms = ["x86_64-linux"];
    };
  }
