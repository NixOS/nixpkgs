{
  appimageTools,
  lib,
  fetchurl,
  makeDesktopItem,
}:

let
  pname = "rambox";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/Rambox-${version}-linux-x64.AppImage";
    hash = "sha256-ndFv5rNTWyqrGGC8t1JNR+bQC0Jsit4I9p4ng7h/gcU=";
  };

  desktopItem = (
    makeDesktopItem {
      desktopName = "Rambox";
      name = pname;
      exec = "rambox";
      icon = pname;
      categories = [ "Network" ];
    }
  );

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/rambox*.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
  '';

  extraPkgs = pkgs: [ pkgs.procps ];

  meta = with lib; {
    description = "Workspace Simplifier - a cross-platform application organizing web services into Workspaces similar to browser profiles";
    homepage = "https://rambox.app";
    license = licenses.unfree;
    maintainers = with maintainers; [ nazarewk ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
