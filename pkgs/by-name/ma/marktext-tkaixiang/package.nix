{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  desktopItem = makeDesktopItem {
    name = "marktext";
    desktopName = "MarkText (Tkaixiang fork)";
    exec = "marktext %U";
    icon = "marktext";
    terminal = false;
    categories = [
      "Office"
      "TextEditor"
      "Utility"
    ];
  };
in
appimageTools.wrapType2 {
  pname = "marktext";
  version = "0.18.6";

  src = fetchurl {
    url = "https://github.com/Tkaixiang/marktext/releases/download/v0.18.6/marktext-linux-0.18.6.AppImage";
    sha256 = "16asgv3laqi2wz22z3bi0ijic2nf20b3bi3srrdrwq2y3hyf0h7h";
  };

  extraInstallCommands = ''
    install -Dm444 \
        ${desktopItem}/share/applications/*.desktop \
        $out/share/applications/marktext.desktop
  '';

  meta = with lib; {
    description = "Unofficial MarkText fork maintained by Tkaixiang (AppImage)";
    homepage = "https://github.com/Tkaixiang/marktext";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "marktext";
  };
}
