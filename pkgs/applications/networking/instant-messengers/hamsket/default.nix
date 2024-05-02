{ lib
, appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "hamsket";
  version = "0.6.5";

  src = fetchurl {
    url = "https://github.com/TheGoddessInari/hamsket/releases/download/nightly/Hamsket-${version}.AppImage";
    sha256 = "sha256-r85ZwcalBd/nCIBxOaQk7XClxj7VZtxwky4eWWm2tZ8=";
  };

  desktopItem = (makeDesktopItem {
    desktopName = "Hamsket";
    name = pname;
    exec = pname;
    icon = pname;
    categories = [ "Network" ];
  });

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/hamsket*.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    description = "A free and open source messaging and emailing app that combines common web applications into one";
    homepage = "https://github.com/TheGoddessInari/hamsket";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nova-madeline ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
