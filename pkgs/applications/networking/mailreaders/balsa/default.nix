{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk3, gmime, gnutls,
  webkitgtk, libesmtp, openssl, libnotify, gtkspell3, gpgme,
  libcanberra-gtk3, libsecret, gtksourceview, gobject-introspection,
  wrapGAppsHook
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
    gtk3
    gmime
    gnutls
    webkitgtk
    openssl
    libnotify
    gtkspell3
    gpgme
    libcanberra-gtk3
    gtksourceview
    libsecret
    libesmtp
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
    homepage = http://pawsa.fedorapeople.org/balsa/;
    description = "An e-mail client for GNOME";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
