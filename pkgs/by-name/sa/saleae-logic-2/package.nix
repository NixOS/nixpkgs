{
  lib,
  fetchurl,
  makeDesktopItem,
  appimageTools,
}:
let
  pname = "saleae-logic-2";
  version = "2.4.29";
  src = fetchurl {
    url = "https://downloads2.saleae.com/logic2/Logic-${version}-linux-x64.AppImage";
    hash = "sha256-eCG2Al6MmWTCiYtaO6qIoNji4QreMryoZRcfKjk5d1c=";
  };
  desktopItem = makeDesktopItem {
    name = "saleae-logic-2";
    exec = "saleae-logic-2";
    icon = "Logic";
    comment = "Software for Saleae logic analyzers";
    desktopName = "Saleae Logic";
    genericName = "Logic analyzer";
    categories = [ "Development" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p $out/etc/udev/rules.d
      cp ${appimageContents}/resources/linux-x64/99-SaleaeLogic.rules $out/etc/udev/rules.d/
      mkdir -p $out/share/pixmaps
      ln -s ${desktopItem}/share/applications $out/share/
      cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/Logic.png $out/share/pixmaps/Logic.png
    '';

  extraPkgs =
    pkgs: with pkgs; [
      wget
      unzip
      glib
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      nss
      nspr
      dbus
      gdk-pixbuf
      gtk3
      pango
      atk
      cairo
      expat
      xorg.libXrandr
      xorg.libXScrnSaver
      alsa-lib
      at-spi2-core
      cups
      libxcrypt-legacy
    ];

  meta = with lib; {
    homepage = "https://www.saleae.com/";
    changelog = "https://ideas.saleae.com/f/changelog/";
    description = "Software for Saleae logic analyzers";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      j-hui
      newam
    ];
  };
}
