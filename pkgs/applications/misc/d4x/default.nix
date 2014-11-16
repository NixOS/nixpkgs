{ stdenv, fetchurl, gtk, glib, pkgconfig, openssl, boost }:

stdenv.mkDerivation {
  name = "d4x-2.5.7.1";

  inherit boost;

  src = fetchurl {
    url =  http://d4x.krasu.ru/files/d4x-2.5.7.1.tar.bz2;
    sha256 = "1i1jj02bxynisqapv31481sz9jpfp3f023ky47spz1v1wlwbs13m";
  };

  buildInputs = [ gtk glib pkgconfig openssl boost ];

  meta = {
    description = "Graphical download manager";
    homepage = http://www.krasu.ru/soft/chuchelo/;
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
  };
}
