{
  pkgs,
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "hayase";
  version = "6.4.50";

  src = pkgs.fetchurl {
    url = "https://api.hayase.watch/files/linux-hayase-${version}-linux.AppImage";
    hash = "sha256-uHtTMlbE53UrKAirEbyn/9dSGZjoCkVpkXE+y4ye1Ko=";
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      cups
      dbus
      gdk-pixbuf
      gtk3
      libdrm
      libglvnd
      libsecret
      mesa
      nspr
      nss
      pango
      xorg.libX11
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libxshmfence
      xorg.libXtst
    ];

  meta = {
    description = "Hayase is a bring your own torrent streaming application primarily geared towards anime watchers";
    homepage = "https://hayase.watch";
    license = lib.licenses.bsl11;
    maintainers = [ lib.maintainers.flaxeneel2 ];
    platforms = [ "x86_64-linux" ];
  };
}
