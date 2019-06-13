{ stdenv, lib, zlib, glib, alsaLib, dbus, gtk2, atk, pango, freetype, fontconfig
, libgnome-keyring3, gdk_pixbuf, cairo, cups, expat, libgpgerror, nspr
, nss, xorg, libcap, systemd, libnotify, libsecret, gnome2 }:

let
  packages = [
    stdenv.cc.cc zlib glib dbus gtk2 atk pango freetype libgnome-keyring3
    fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor xorg.libxkbfile xorg.libXScrnSaver libcap systemd libnotify
    xorg.libxcb libsecret gnome2.GConf
  ];

  libPathNative = lib.makeLibraryPath packages;
  libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
  libPath = "${libPathNative}:${libPath64}";

in { inherit packages libPath; }
