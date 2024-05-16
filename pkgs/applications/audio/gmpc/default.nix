{ lib
, stdenv
, fetchurl
, libtool
, intltool
, pkg-config
, glib
, gtk2
, curl
, libmpdclient
, libsoup
, gob2
, vala
, libunique
, libSM
, libICE
, sqlite
, hicolor-icon-theme
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "gmpc";
  version = "11.8.16";

  libmpd = stdenv.mkDerivation {
    pname = "libmpd";
    version = "11.8.17";
    src = fetchurl {
      url = "https://download.sarine.nl/Programs/gmpc/${lib.versions.majorMinor version}/libmpd-${version}.tar.gz";
      sha256 = "10vspwsgr8pwf3qp2bviw6b2l8prgdiswgv7qiqiyr0h1mmk487y";
    };
    patches = [ ./libmpd-11.8.17-remove-strndup.patch ];

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ glib ];
  };

  src = fetchurl {
    url = "http://download.sarine.nl/Programs/gmpc/11.8/gmpc-11.8.16.tar.gz";
    sha256 = "0b3bnxf98i5lhjyljvgxgx9xmb6p46cn3a9cccrng14nagri9556";
  };

  nativeBuildInputs = [ pkg-config libtool intltool gob2 vala wrapGAppsHook3 ];
  buildInputs = [
    glib
    gtk2
    curl
    libmpdclient
    libsoup
    libunique
    libmpd
    libSM
    libICE
    sqlite
    hicolor-icon-theme
  ];

  meta = with lib; {
    homepage = "https://gmpclient.org";
    description = "A GTK2 frontend for Music Player Daemon";
    license = licenses.gpl2;
    maintainers = [];
    platforms = platforms.linux;
  };
}
# TODO: what is this libmpd derivation embedded above?
