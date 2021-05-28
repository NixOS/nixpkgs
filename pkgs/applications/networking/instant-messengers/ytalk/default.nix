{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ytalk";
  version = "3.3.0";

  src = fetchurl {
    url = "ftp://ftp.ourproject.org/pub/ytalk/${pname}-${version}.tar.gz";
    sha256 = "1d3jhnj8rgzxyxjwfa22vh45qwzjvxw1qh8fz6b7nfkj3zvk9jvf";
  };

  buildInputs = [ ncurses ];

  meta = {
    homepage    = "http://ytalk.ourproject.org";
    description = "A terminal based talk client";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ taeer ];
    license     = stdenv.lib.licenses.gpl2Plus;
  };
}
