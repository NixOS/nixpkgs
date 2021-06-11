{ stdenv, lib, zlib, glib, alsa-lib, dbus, gtk3, atk, pango, freetype, fontconfig
, libgnome-keyring3, gdk-pixbuf, cairo, cups, expat, libgpgerror, nspr
, gconf, nss, xorg, libcap, systemd, libnotify, libsecret, libuuid, at-spi2-atk
, at-spi2-core, libdbusmenu, libdrm, mesa
}:

let
  packages = [
    stdenv.cc.cc zlib glib dbus gtk3 atk pango freetype libgnome-keyring3
    fontconfig gdk-pixbuf cairo cups expat libgpgerror alsa-lib nspr gconf nss
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
