{ stdenv, lib, fetchurl, dpkg, electron, gnome2, atk, cairo, gdk_pixbuf
, glib, zulu, zulu8, freetype, fontconfig, fontconfig_210, dbus_daemon
, xlibs, gnome3, glib-tested, nss, nspr, alsaLib, cups, expat, nodejs
, libudev
}:
let
  rpath = lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups.lib
    dbus_daemon.lib
    electron
    expat
    fontconfig
    fontconfig_210
    freetype
    gdk_pixbuf
    glib
    glib-tested
    gnome2.GConf
    gnome2.gtk
    gnome2.pango
    gnome3.gconf
    libudev
    nodejs
    nspr
    nss
    stdenv.cc.cc
    xlibs.libX11
    xlibs.libX11
    xlibs.libXScrnSaver
    xlibs.libXcomposite
    xlibs.libXcursor
    xlibs.libXdamage
    xlibs.libXext
    xlibs.libXfixes
    xlibs.libXi
    xlibs.libXrandr
    xlibs.libXrender
    xlibs.libXtst
    xlibs.libxcb
    zulu
    zulu8
  ] + ":${stdenv.cc.cc.lib}/lib64";

in
  stdenv.mkDerivation rec {
    name = "signal-desktop-${version}";

    version = "1.0.35";

    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
          sha256 = "d9f9d4d54f4121efc8eadf1cf0ff957828088b313e53b66dc540b851c44c1860";
        }
      else
        throw "Signal for Desktop is not currently supported on ${stdenv.system}";

    nativeBuildInputs = [ dpkg ];
    unpackPhase = "true";
    buildCommand = ''
      mkdir -p $out
      dpkg -x $src $out

      mv $out/usr/share $out/share
      mv $out/opt/Signal $out/libexec
      rmdir $out/usr $out/opt

      chmod -R g-w $out

      # Patch signal
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/libexec/signal-desktop
      patchelf --set-rpath ${rpath}:$out/libexec $out/libexec/signal-desktop

      # Symlink to bin
      mkdir -p $out/bin
      ln -s $out/libexec/signal-desktop $out/bin/signal-desktop

      # Fix the desktop link
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace /opt/Signal/signal-desktop $out/bin/signal-desktop
    '';

    meta = {
      description = "Signal messenger for the desktop.";
      homepage = https://signal.org/;
      license = lib.licenses.gpl3;
      platforms = [
        "x86_64-linux"
      ];
    };
  }
