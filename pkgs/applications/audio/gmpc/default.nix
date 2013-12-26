{ stdenv, fetchurl, libtool, intltool, pkgconfig, glib
, gtk, curl, mpd_clientlib, libsoup, gob2, vala, libunique
}:

stdenv.mkDerivation rec {
  name = "gmpc-${version}";
  version = "11.8.16";

  libmpd = stdenv.mkDerivation {
    name = "libmpd-11.8.17";
    src = fetchurl {
      url = http://download.sarine.nl/Programs/gmpc/11.8/libmpd-11.8.17.tar.gz;
      sha256 = "10vspwsgr8pwf3qp2bviw6b2l8prgdiswgv7qiqiyr0h1mmk487y";
    };
    buildInputs = [ pkgconfig glib ];
  };

  src = fetchurl {
    url = "http://download.sarine.nl/Programs/gmpc/11.8/gmpc-11.8.16.tar.gz";
    sha256 = "0b3bnxf98i5lhjyljvgxgx9xmb6p46cn3a9cccrng14nagri9556";
  };

  buildInputs = [
    libtool intltool pkgconfig glib gtk curl mpd_clientlib libsoup
    libunique libmpd gob2 vala
  ];

  meta = with stdenv.lib; {
    homepage = http://gmpclient.org;
    description = "A GTK2 frontend for Music Player Daemon";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
