{ stdenv, lib, zlib, glib, alsaLib, dbus, gtk2, atk, pango, freetype, fontconfig
, libgnome_keyring3, gdk_pixbuf, gvfs, cairo, cups, expat, libgpgerror, nspr
, gconf, nss, xorg, libcap, systemd, libnotify, libsecret
}:

let
  packages = [
    stdenv.cc.cc zlib glib dbus gtk2 atk pango freetype libgnome_keyring3
    fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor xorg.libxkbfile xorg.libXScrnSaver libcap systemd libnotify
    xorg.libxcb libsecret
  ];

  libPathNative = lib.makeLibraryPath packages;
  libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
  libPath = "${libPathNative}:${libPath64}";

in { inherit packages libPath; }
