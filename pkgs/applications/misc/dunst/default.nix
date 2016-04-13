{ stdenv, fetchurl, coreutils, unzip, which, pkgconfig, dbus
, freetype, xdg_utils, libXext, glib, pango, cairo, libX11, libnotify
, libxdg_basedir, libXScrnSaver, xproto, libXinerama, perl, gdk_pixbuf
, dbus_daemon, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "dunst-1.1.0";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/knopwob/dunst/archive/v${version}.tar.gz";
    sha256 = "0x95f57s0a96c4lifxdpf73v706iggwmdw8742mabbjnxq55l1qs";
  };

  buildInputs =
  [ coreutils unzip which pkgconfig dbus freetype libnotify gdk_pixbuf
    xdg_utils libXext glib pango cairo libX11 libxdg_basedir
    libXScrnSaver xproto libXinerama perl dbus_daemon makeWrapper ];

  buildPhase = ''
    export VERSION=${version};
    export PREFIX=$out;
    make dunst;
  '';

  postFixup = ''
    wrapProgram "$out/bin/dunst" \
      --prefix PATH : '${dbus_daemon.out}/bin'
  '';

  meta = {
    description = "lightweight and customizable notification daemon";
    homepage = http://www.knopwob.org/dunst/;
    license = stdenv.lib.licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
