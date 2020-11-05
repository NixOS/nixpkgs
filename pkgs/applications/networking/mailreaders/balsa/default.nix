{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk3, gmime, gnutls,
  webkitgtk, libesmtp, openssl, libnotify, gtkspell3, gpgme,
  libcanberra-gtk3, libsecret, gtksourceview, gobject-introspection,
  wrapGAppsHook, libical
}:

stdenv.mkDerivation rec {
  pname = "balsa";
  version = "2.5.11";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${pname}-${version}.tar.bz2";
    sha256 = "1w8cbrj0w90fc2kxdf94krkwdh58w5px9qmkiqcb6rlm06n0wg9d";
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
    libical
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
