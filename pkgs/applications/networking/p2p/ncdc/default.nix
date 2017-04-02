{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

stdenv.mkDerivation rec {
  name = "ncdc-${version}";
  version = "1.20";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "0ccn7dqbqpqsbglqyalz32c20rjvf1pw0zr88jyvd2b2vxbqi6ca";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses zlib bzip2 sqlite glib gnutls ];

  meta = with stdenv.lib; {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = http://dev.yorhel.nl/ncdc;
    license = licenses.mit;
    platforms = platforms.linux; # arbitrary
    maintainers = with maintainers; [ ehmry ];
  };
}
