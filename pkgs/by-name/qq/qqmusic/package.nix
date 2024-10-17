{
  fetchurl,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  lib,
  makeDesktopItem,
  copyDesktopItems,
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
  mesa,
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
  version = "1.1.5";
  src = fetchurl {
    url = "https://dldir1.qq.com/music/clntupate/linux/deb/qqmusic_${finalAttrs.version}_amd64_.deb";
    sha256 = "sha256-wTtO80S8o4/EeVCvBzaN4xtI3+mShTjNHpq41exfP+g=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
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
    mesa
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
    ar x $src
    tar xf data.tar.xz
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
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"

    # Hex patch from https://aur.archlinux.org/packages/qqmusic-bin
    # 1. Fix orphaned processes
    # 2. Fix search
    local _subst="
        s|\xA4\x8B\x7A\xB9\x8D\xCF\x54\xAE|\xA4\x8B\x7A\xB9\x85\xEF\x54\xAE|
        s|\xB3\x1D\xF5\xCB\x24\xBC|\xA3\x63\xBB\xC9\x3F\xBC|
    "
    sed "$_subst" -i "$out/opt/resources/app.asar"

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
