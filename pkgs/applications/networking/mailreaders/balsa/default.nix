{ stdenv
, fetchurl
, glib
, gmime
, gnutls
, gobject-introspection
, gpgme
, gtk3
, gtksourceview
, gtkspell3
, intltool
, libcanberra-gtk3
, libesmtp
, libnotify
, libsecret
, openssl
, pkgconfig
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "balsa";
  version = "2.5.9";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${pname}-${version}.tar.bz2";
    sha256 = "19gs1qfvbk9qx4rjmgrmvid00kl9k153zjjx8zjii2lz09w7g19i";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gmime
    gnutls
    gpgme
    gtk3
    gtksourceview
    gtkspell3
    libcanberra-gtk3
    libesmtp
    libnotify
    libsecret
    openssl
    webkitgtk
  ];

  configureFlags = [
    "--with-canberra"
    "--with-gpgme"
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
