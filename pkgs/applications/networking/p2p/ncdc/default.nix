{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

let
  version = "1.19.1";
in
stdenv.mkDerivation {
  name = "ncdc-${version}";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "0iwx4b3x207sw11qqjfynpwnhryhixjzbgcy9l9zfisa8f0k7cm6";
  };

  buildInputs = [ ncurses zlib bzip2 sqlite pkgconfig glib gnutls ];

  meta = {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = http://dev.yorhel.nl/ncdc;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux; # arbitrary
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}
