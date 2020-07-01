{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

stdenv.mkDerivation rec {
  pname = "ncdc";
  version = "1.22.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "1bdgqd07f026qk6vpbxqsin536znd33931m3b4z44prlm9wd6pyi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses zlib bzip2 sqlite glib gnutls ];

  meta = with stdenv.lib; {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdc";
    license = licenses.mit;
    platforms = platforms.linux; # arbitrary
    maintainers = with maintainers; [ ehmry ];
  };
}
