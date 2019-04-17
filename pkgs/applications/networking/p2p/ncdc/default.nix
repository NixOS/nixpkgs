{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

stdenv.mkDerivation rec {
  name = "ncdc-${version}";
  version = "1.21";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "10hrk7pcvfl9cj6d0kr4qf3l068ikqhccbg7lf25pr2kln9lz412";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses zlib bzip2 sqlite glib gnutls ];

  meta = with stdenv.lib; {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = https://dev.yorhel.nl/ncdc;
    license = licenses.mit;
    platforms = platforms.linux; # arbitrary
    maintainers = with maintainers; [ ehmry ];
  };
}
