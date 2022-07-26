{ stdenv, lib, zlib, glib, alsa-lib, dbus, gtk3, atk, pango, freetype, fontconfig
, gdk-pixbuf, cairo, cups, expat, libgpg-error, nspr
, nss, xorg, libcap, systemd, libnotify, libsecret, libuuid, at-spi2-atk
, at-spi2-core, libdbusmenu, libdrm, mesa
}:

let
  packages = [
    stdenv.cc.cc zlib glib dbus gtk3 atk pango freetype
    fontconfig gdk-pixbuf cairo cups expat libgpg-error alsa-lib nspr nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor xorg.libxkbfile xorg.libXScrnSaver libcap systemd libnotify
    xorg.libxcb libsecret libuuid at-spi2-atk at-spi2-core libdbusmenu
    libdrm
    mesa # required for libgbm
  ];

  libPathNative = lib.makeLibraryPath packages;
  libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
  libPath = "${libPathNative}:${libPath64}";

in { inherit packages libPath; }
