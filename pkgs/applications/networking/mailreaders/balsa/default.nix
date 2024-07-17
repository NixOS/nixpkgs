{
  lib,
  stdenv,
  fetchurl,
  glib,
  gmime3,
  gnutls,
  gobject-introspection,
  gpgme,
  gtk3,
  gtksourceview4,
  gtkspell3,
  intltool,
  libcanberra-gtk3,
  libesmtp,
  libical,
  libnotify,
  libsecret,
  openssl,
  pkg-config,
  sqlite,
  webkitgtk,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "balsa";
  version = "2.6.4";

  src = fetchurl {
    url = "https://pawsa.fedorapeople.org/balsa/${pname}-${version}.tar.xz";
    sha256 = "1hcgmjka2x2igdrmvzlfs12mv892kv4vzv5iy90kvcqxa625kymy";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gmime3
    gnutls
    gpgme
    gtk3
    gtksourceview4
    gtkspell3
    libcanberra-gtk3
    libesmtp
    libical
    libnotify
    libsecret
    openssl
    sqlite
    webkitgtk
  ];

  configureFlags = [
    "--with-canberra"
    "--with-gtksourceview"
    "--with-libsecret"
    "--with-spell-checker=gtkspell"
    "--with-sqlite"
    "--with-ssl"
    "--with-unique"
    "--without-gnome"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://pawsa.fedorapeople.org/balsa/";
    description = "E-mail client for GNOME";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
