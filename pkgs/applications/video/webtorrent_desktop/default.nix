{
  alsaLib, atk, cairo, cups, dbus, dpkg, expat, fetchurl, fontconfig, freetype,
  gdk_pixbuf, glib, gnome2, libX11, libXScrnSaver, libXcomposite, libXcursor,
  libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst,
  libxcb, nspr, nss, stdenv, udev
}:

  let
    rpath = stdenv.lib.makeLibraryPath ([
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gnome2.gtk
    gnome2.pango
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    nspr
    nss
    stdenv.cc.cc
    udev
    ]);
  in stdenv.mkDerivation rec {
    name = "webtorrent-desktop-${version}";
    version = "0.20.0";

    src =
      if stdenv.system == "x86_64-linux" then
        fetchurl {
          url = "https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.20.0/webtorrent-desktop_${version}-1_amd64.deb";
          sha256 = "1kkrnbimiip5pn2nwpln35bbdda9gc3cgrjwphq4fqasbjf2781k";
        }
        else
          throw "Webtorrent is not currently supported on ${stdenv.system}";
    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ dpkg ];
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out
      cp -R opt $out

      mv ./usr/share $out/share
      mv $out/opt/webtorrent-desktop $out/libexec
      chmod +x $out/libexec/WebTorrent
      rmdir $out/opt

      chmod -R g-w $out

      # Patch WebTorrent
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
               --set-rpath ${rpath}:$out/libexec $out/libexec/WebTorrent

      # Symlink to bin
      mkdir -p $out/bin
      ln -s $out/libexec/WebTorrent $out/bin/WebTorrent

      # Fix the desktop link
      substituteInPlace $out/share/applications/webtorrent-desktop.desktop \
        --replace /opt/webtorrent-desktop $out/bin
    '';

    meta = with stdenv.lib; {
      description = "Streaming torrent app for Mac, Windows, and Linux.";
      homepage = https://webtorrent.io/desktop;
      license = licenses.mit;
      maintainers = [ maintainers.flokli ];
      platforms = [
        "x86_64-linux"
      ];
    };
  }
