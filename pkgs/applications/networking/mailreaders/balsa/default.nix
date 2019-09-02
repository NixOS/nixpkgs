{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk3, gmime, gnutls,
  webkitgtk, libesmtp, openssl, libnotify, gtkspell3, gpgme,
  libcanberra-gtk3, libsecret, gtksourceview, gobject-introspection,
  hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "balsa";
  version = "2.5.7";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${pname}-${version}.tar.bz2";
    sha256 = "0yfqhfpwm1qnwmbpr6dfn2f5w8a8xxq51pn8ypgg0fw973l1c1nx";
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
