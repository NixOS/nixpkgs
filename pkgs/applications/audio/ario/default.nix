{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, avahi
, curl
, dbus-glib
, gettext
, gtk3
, libmpdclient
, libsoup
, libxml2
, taglib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ario";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sourceforge/ario-player/${pname}-${version}.tar.gz";
    sha256 = "16nhfb3h5pc7flagfdz7xy0iq6kvgy6h4bfpi523i57rxvlfshhl";
  };

  nativeBuildInputs = [ pkg-config gettext intltool wrapGAppsHook ];
  buildInputs = [
    avahi
    curl
    dbus-glib
    gtk3
    libmpdclient
    libsoup
    libxml2
    taglib
  ];

  meta = with lib; {
    description = "GTK client for MPD (Music player daemon)";
    homepage = "http://ario-player.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.garrison ];
    platforms = platforms.all;
  };
}
