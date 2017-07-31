{ stdenv, fetchurl, pkgconfig, gettext, gtk2, expat, intltool, libgcrypt,
  libunique, gnutls, libxml2, curl, mpd_clientlib, dbus_glib, libnotify,
  libsoup, avahi, taglib
  }:

stdenv.mkDerivation rec {
  version = "1.5.1";
  name = "ario-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ario-player/${name}.tar.gz";
    sha256 = "07n97618jv1ilxnm5c6qj9zjz0imw3p304mn4hjbjkk3p0d2hc88";
  };

  patches = [ ./glib-single-include.patch ];

  buildInputs = [
    pkgconfig gettext gtk2 expat intltool libgcrypt libunique gnutls
    libxml2 curl mpd_clientlib dbus_glib libnotify libsoup avahi taglib
  ];

  meta = {
    description = "GTK2 client for MPD (Music player daemon)";
    homepage = http://ario-player.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
