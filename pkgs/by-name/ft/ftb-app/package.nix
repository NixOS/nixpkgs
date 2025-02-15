{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  copyDesktopItems,
}: let
  pname = "ftb-app";
  version = "1.27.2";

  src = fetchurl {
    url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-x86_64.AppImage";
    sha256 = "35GEI1OBvVkUvHvQAzzGz8ux9h+5W3acH0Wr5VkqyBw=";
  };
in
  appimageTools.wrapType2 rec {
    inherit pname src version;

    desktopItem = makeDesktopItem {
      name = "FTB App";
      desktopName = "FTB App";
      exec = "ftb-app";
      icon = "ftb-app";
      comment = "Feed the Beast desktop app";
      categories = ["Game"];
    };

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/
    '';

    meta = {
      description = "Feed the Beast desktop app";
      homepage = "https://www.feed-the-beast.com/ftb-app";
      changelog = "https://www.feed-the-beast.com/ftb-app/changes#1.27.2";
      license = lib.licenses.lgpl21;
      maintainers = with lib.maintainers; [ nagymathev ];
      mainProgram = "ftb-app";
      platforms = lib.platforms.linux;
    };
  }
