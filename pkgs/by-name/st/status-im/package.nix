{
  lib,
  appimageTools,
  fetchzip,
  fetchurl,
  makeDesktopItem,
}:
let
  version = "2.29.0";
  commit = "f78ece";

  src = fetchzip {
    name = "StatusIm-Desktop-v${version}-${commit}-x86_64.AppImage";
    url = "https://github.com/status-im/status-desktop/releases/download/${version}/StatusIm-Desktop-v${version}-${commit}-x86_64.tar.gz";
    hash = "sha256-i91E1eaN6paM+uZ8EvO1+Wj0Po9KnzQorG0tWKF4hn8=";
    stripRoot = false;
    postFetch = ''
      mv $out/StatusIm-Desktop-v${version}-${commit}-x86_64.AppImage $TMPDIR/tmp
      rm -rf $out
      mv $TMPDIR/tmp $out
    '';
  };

  desktopEntry = makeDesktopItem {
    name = "status";
    desktopName = "Status Desktop";
    exec = "status-desktop";
    icon = "status";
    comment = "Desktop client for the Status Network";
    categories = [ "Network" ];
  };
  icon = fetchurl {
    url = "https://github.com/status-im/status-desktop/raw/afde83651724a555626b5d9a3d582918de6c3d59/status.png";
    hash = "sha256-ViGuOr9LskGs/P7pjPO9zYgosWaZlZZYVuPpliOA5dY=";
  };
  pname = "status-desktop";
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${desktopEntry}/share/applications/status.desktop $out/share/applications/status.desktop
    install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/status.png
  '';
  meta = with lib; {
    description = "Desktop client for the Status Network";
    license = licenses.mpl20;
    maintainers = with maintainers; [ a-kenji ];
    platforms = platforms.linux;
  };
}
