{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "bviplus";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/bviplus/bviplus/${version}/bviplus-${version}.tgz";
    sha256 = "08q2fdyiirabbsp5qpn3v8jxp4gd85l776w6gqvrbjwqa29a8arg";
  };

  buildInputs = [
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "CFLAGS=-fgnu89-inline" ];

  meta = with stdenv.lib; {
    description = "Ncurses based hex editor with a vim-like interface";
    homepage = http://bviplus.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
