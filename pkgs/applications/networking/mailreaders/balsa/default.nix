{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk3, gmime, gnutls,
  webkitgtk, libesmtp, openssl, libnotify, enchant, gpgme,
  libcanberra-gtk3, libsecret, gtksourceview, gobjectIntrospection,
  hicolor-icon-theme, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "balsa-${version}";
  version = "2.5.5";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${name}.tar.bz2";
    sha256 = "0p4w81wvdxqhynkninzglsgqk6920x1zif2zmw8bml410lav2azz";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    gobjectIntrospection
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
    enchant
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
