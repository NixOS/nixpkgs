{ stdenv, fetchgit, bison2, flex }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pcalc-${version}";
  version = "20141224";

  src = fetchgit {
    url = git://git.code.sf.net/p/pcalc/code;
    rev = "181d60d3c880da4344fef7138065943eb3b9255f";
    sha256 = "1hd5bh20j5xzvv6qa0fmzmv0h8sf38r7zgi7y0b6nk17pjq33v90";
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
