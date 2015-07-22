{ stdenv, fetchgit, bison2, flex }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pcalc-${version}";
  version = "20141224";

  src = fetchgit {
    url = git://git.code.sf.net/p/pcalc/code;
    rev = "181d60d3c880da4344fef7138065943eb3b9255f";
    sha256 = "0n60m3p4kkqvvswjf50mnfaaacmzi1lss8vgy63mrgzwi9v6yb4l";
  };

  makeFlags = [ "DESTDIR= BINDIR=$(out)/bin" ];
  buildInputs = [ bison2 flex ];

  meta = {
    homepage = http://pcalc.sourceforge.net/;
    description = "Programmer's calculator";
    license = licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
