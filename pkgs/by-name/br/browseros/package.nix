{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  stdenv,
  ...
}:

let
  pname = "browseros";
  version = "0.25.0";

  desktopItem = makeDesktopItem {
    name = "${pname}";
    exec = "${pname}";
    icon = "${pname}";
    type = "Application";
    desktopName = "BrowserOS";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

  src = fetchurl {
    name = "browseros.AppImage";
    sha256 = "sha256-Tgx6NylEea/zGODT/+6QfZX5ipVXguNNURa1vHilHSM=";
    url = "https://github.com/browseros-ai/BrowserOS/releases/download/v${version}/BrowserOS_v${version}_x64.AppImage";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname src version;

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    cp ${desktopItem}/share/applications/* $out/share/applications
    cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/${pname}.png $out/share/icons/hicolor/256x256/apps/${pname}.png
  '';

  meta = {
    homepage = "https://www.browseros.com";
    description = "The Open source agentic browser";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ cawilliamson ];
    mainProgram = "browseros";
  };
}
