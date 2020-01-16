{
  alsaLib, atk, cairo, cups, dbus, dpkg, expat, fetchurl, fontconfig, freetype,
  gdk-pixbuf, glib, gnome2, libX11, libXScrnSaver, libXcomposite, libXcursor,
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
    gdk-pixbuf
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
    pname = "webtorrent-desktop";
    version = "0.21.0";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://github.com/webtorrent/webtorrent-desktop/releases/download/v${version}/webtorrent-desktop_${version}_amd64.deb";
          sha256 = "012mf5sa5z234p3yjjphcr49anc2vna6h90mdmgc439z7l6krvrm";
        }
        else
          throw "Webtorrent is not currently supported on ${stdenv.hostPlatform.system}";
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
      homepage = "https://webtorrent.io/desktop";
      license = licenses.mit;
      maintainers = [ maintainers.flokli ];
      platforms = [
        "x86_64-linux"
      ];
    };
  }
