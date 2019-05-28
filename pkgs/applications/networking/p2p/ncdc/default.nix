{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

stdenv.mkDerivation rec {
  name = "ncdc-${version}";
  version = "1.22";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "0n9sn4rh4zhmzjknsvyp4bfh925abz93ln43gl8a1v63rs2yyhgx";
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
