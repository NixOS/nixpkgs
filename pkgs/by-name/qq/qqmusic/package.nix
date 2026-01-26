{
  fetchurl,
  lib,
  stdenvNoCC,

  # darwin
  undmg,

  # linux
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  dpkg,

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
let
  pname = "qqmusic";

  meta = {
    maintainers = with lib.maintainers; [
      prince213
      xddxdd
    ];
    description = "Tencent QQ Music";
    homepage = "https://y.qq.com/";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "qqmusic";
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  import ./darwin.nix {
    inherit
      meta
      pname

      fetchurl
      stdenvNoCC
      undmg
      ;
  }
else
  import ./linux.nix {
    inherit
      meta
      pname

      autoPatchelfHook
      copyDesktopItems
      dpkg
      fetchurl
      lib
      makeDesktopItem
      makeWrapper
      stdenvNoCC

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
      xorg
      ;
  }
