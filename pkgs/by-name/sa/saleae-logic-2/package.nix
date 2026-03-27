{
  lib,
  fetchurl,
  makeDesktopItem,
  appimageTools,
}:
let
  pname = "saleae-logic-2";
  version = "2.4.40";
  src = fetchurl {
    url = "https://downloads2.saleae.com/logic2/Logic-${version}-linux-x64.AppImage";
    hash = "sha256-TG7fH8b0L/O8RjlMB3QJM3/8my49uBX2RwufrVWDgpI=";
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
      mkdir $out/share
      ln -s ${desktopItem}/share/applications $out/share/
      for size in 16 32 48 64 128 256; do
        install -Dm644 -t $out/share/icons/hicolor/"$size"x"$size"/apps \
          ${appimageContents}/usr/share/icons/hicolor/"$size"x"$size"/apps/Logic.png
      done
    '';

  extraPkgs =
    pkgs: with pkgs; [
      wget
      unzip
      glib
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrender
      libxtst
      nss
      nspr
      dbus
      gdk-pixbuf
      gtk3
      pango
      atk
      cairo
      expat
      libxrandr
      libxscrnsaver
      alsa-lib
      at-spi2-core
      cups
      libxcrypt-legacy
    ];

  meta = {
    homepage = "https://www.saleae.com/";
    changelog = "https://ideas.saleae.com/f/changelog/";
    description = "Software for Saleae logic analyzers";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      j-hui
      newam
    ];
  };
}
