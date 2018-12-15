{ stdenv, fetchurl, pkgconfig, gettext, gtk3, intltool,
  wrapGAppsHook, libxml2, curl, mpd_clientlib, dbus-glib,
  libsoup, avahi, taglib
  }:

stdenv.mkDerivation rec {
  version = "1.6";
  name = "ario-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ario-player/${name}.tar.gz";
    sha256 = "16nhfb3h5pc7flagfdz7xy0iq6kvgy6h4bfpi523i57rxvlfshhl";
  };

  nativeBuildInputs = [ pkgconfig gettext intltool wrapGAppsHook ];
  buildInputs = [
    gtk3 libxml2 curl mpd_clientlib dbus-glib libsoup avahi taglib
  ];

  meta = {
    description = "GTK client for MPD (Music player daemon)";
    homepage = http://ario-player.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garrison ];
    platforms = stdenv.lib.platforms.all;
  };
}
