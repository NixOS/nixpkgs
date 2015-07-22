{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "bviplus-${version}";
  version = "0.9.4";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/bviplus/bviplus/${version}/bviplus-${version}.tgz";
    sha256 = "10x6fbn8v6i0y0m40ja30pwpyqksnn8k2vqd290vxxlvlhzah4zb";
  };
  buildInputs = [
    ncurses
  ];
  makeFlags = "PREFIX=$(out)";
  meta = with lib; {
    description = "ncurses based hex editor with a vim-like interface";
    homepage = "http://bviplus.sourceforge.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
