{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk3, gmime, gnutls,
  webkitgtk, libesmtp, openssl, libnotify, gtkspell3, gpgme,
  libcanberra-gtk3, libsecret, gtksourceview, gobject-introspection,
  hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "balsa-${version}";
  version = "2.5.6";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${name}.tar.bz2";
    sha256 = "17k6wcsl8gki7cskr3hhmfj6n54rha8ca3b6fzd8blsl5shsankx";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gobject-introspection
    hicolor-icon-theme
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
