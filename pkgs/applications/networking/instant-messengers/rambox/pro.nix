{ appimageTools, fetchurl, makeDesktopItem }:

let
  name = "ramboxpro";
  version = "1.4.1";

  desktopItem = makeDesktopItem {
    name = "rambox-pro";
    exec = "ramboxpro";
    icon = "ramboxpro";
    type = "Application";
    desktopName = "Rambox Pro";
    categories = "Network;";
  };

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/RamboxPro-${version}-linux-x64.AppImage";
    name = "${name}.AppImage";
    sha256 = "18383v3g26hd1czvw06gmjn8bdw2w9c7zb04zkfl6szgakrv26x4";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
    inherit name src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
      cp ${desktopItem}/share/applications/* $out/share/applications
      cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/ramboxpro.png $out/share/icons/hicolor/256x256/apps/ramboxpro.png
    '';
  };

  meta = with stdenv.lib; {
    description = "Messaging and emailing app that combines common web applications into one";
    homepage = "https://rambox.pro";
    license = licenses.unfree;
    maintainers = with maintainers; [ chrisaw ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
