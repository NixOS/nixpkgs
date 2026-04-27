{
  appimageTools,
  lib,
  fetchurl,
  makeDesktopItem,
}:

appimageTools.wrapType2 rec {
  pname = "rambox";
  version = "2.5.2";

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${version}/Rambox-${version}-linux-x64.AppImage";
    hash = "sha256-sx/XLrsDIt2cF4xv/J5i1ZTMf7eHsccBjPEMJ/WISmg=";
  };

  desktopItem = makeDesktopItem {
    desktopName = "Rambox";
    name = "rambox";
    exec = "rambox";
    icon = "rambox";
    categories = [ "Network" ];
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/rambox*.png $out/share/icons/hicolor/256x256/apps/rambox.png
    install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
  '';

  extraPkgs = pkgs: [ pkgs.procps ];

  meta = {
    description = "Workspace Simplifier - a cross-platform application organizing web services into Workspaces similar to browser profiles";
    homepage = "https://rambox.app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ nazarewk ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
