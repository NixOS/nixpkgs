{
  fetchurl,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  dpkg,
  # QQ Music dependencies
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdbusmenu,
  libglvnd,
  libpulseaudio,
  nspr,
  nss,
  pango,
  pciutils,
  udev,
  xorg,
}:
################################################################################
# Mostly based on qqmusic-bin package from AUR:
# https://aur.archlinux.org/packages/qqmusic-bin
################################################################################
stdenv.mkDerivation (finalAttrs: {
  pname = "qqmusic";
  version = "1.1.7";
  src = fetchurl {
    url = "https://dldir1.qq.com/music/clntupate/linux/qqmusic_${finalAttrs.version}_amd64.deb";
    hash = "sha256-NPJHH7VwTzdNY87jFh28GaPjT7kRMweGI/XTOBAzM5E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
    dpkg
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdbusmenu
    libglvnd
    libpulseaudio
    nspr
    nss
    pango
    pciutils
    udev
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/qqmusic $out/opt
    cp -r usr/* $out/

    rm -rf $out/opt/swiftshader
    ln -sf ${libglvnd}/lib $out/opt/swiftshader

    mkdir -p $out/bin
    makeWrapper $out/opt/qqmusic $out/bin/qqmusic \
      --argv0 "qqmusic" \
      --add-flags "--no-sandbox" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "qqmusic";
      desktopName = "QQMusic";
      exec = "qqmusic %U";
      terminal = false;
      icon = "qqmusic";
      startupWMClass = "qqmusic";
      comment = "Tencent QQMusic";
      categories = [ "AudioVideo" ];
      extraConfig = {
        "Name[zh_CN]" = "QQ音乐";
        "Name[zh_TW]" = "QQ音乐";
        "Comment[zh_CN]" = "腾讯QQ音乐";
        "Comment[zh_TW]" = "腾讯QQ音乐";
      };
    })
  ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Tencent QQ Music";
    homepage = "https://y.qq.com/";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
