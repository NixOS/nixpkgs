{ stdenv
, fetchurl
, glib
, gmime3
, gnutls
, gobject-introspection
, gpgme
, gtk3
, gtksourceview
, gtkspell3
, intltool
, libcanberra-gtk3
, libesmtp
, libical
, libnotify
, libsecret
, openssl
, pkgconfig
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "balsa";
  version = "2.6.1";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${pname}-${version}.tar.bz2";
    sha256 = "1xkxx801p7sbfkn0bh3cz85wra4xf1z1zhjqqc80z1z1nln7fhb4";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gmime3
    gnutls
    gpgme
    gtk3
    gtksourceview
    gtkspell3
    libcanberra-gtk3
    libesmtp
    libical
    libnotify
    libsecret
    openssl
    webkitgtk
  ];

  configureFlags = [
    "--with-canberra"
    "--with-gtksourceview"
    "--with-libsecret"
    "--with-ssl"
    "--with-unique"
    "--without-gnome"
    "--with-spell-checker=gtkspell"
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://pawsa.fedorapeople.org/balsa/";
    description = "An e-mail client for GNOME";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
