{ stdenv, lib, zlib, glib, alsaLib, dbus, gtk, atk, pango, freetype, fontconfig
, libgnome_keyring3, gdk_pixbuf, gvfs, cairo, cups, expat, libgpgerror, nspr
, gconf, nss, xorg, libcap, systemd, libnotify
}:

let
  packages = [
    stdenv.cc.cc zlib glib dbus gtk atk pango freetype libgnome_keyring3
    fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor libcap systemd libnotify
  ];

  libPathNative = lib.makeLibraryPath packages;
  libPath64 = lib.makeSearchPathOutputs "lib64" ["lib"] packages;
  libPath = "${libPathNative}:${libPath64}";

in { inherit packages libPath; }
