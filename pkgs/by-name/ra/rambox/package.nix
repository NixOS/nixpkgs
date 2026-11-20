{
  appimageTools,
  lib,
  fetchurl,
  makeDesktopItem,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "rambox";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github.com/ramboxapp/download/releases/download/v${finalAttrs.version}/Rambox-${finalAttrs.version}-linux-x64.AppImage";
    hash = "sha256-v+zf28sn2LlEs33ZQBsNgvIO6aTcM6EJJVwrcJoArwE=";
  };

  desktopItem = makeDesktopItem {
    desktopName = "Rambox";
    name = "rambox";
    exec = "rambox";
    icon = "rambox";
    categories = [ "Network" ];
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    install -Dm644 ${finalAttrs.contents}/usr/share/icons/hicolor/256x256/apps/rambox*.png $out/share/icons/hicolor/256x256/apps/rambox.png
    install -Dm644 ${finalAttrs.desktopItem}/share/applications/* $out/share/applications
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
})
