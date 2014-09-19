{ stdenv, fetchgit, bison2, flex }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pcalc-${version}";
  version = "20120812";

  src = fetchgit {
    url = git://git.code.sf.net/p/pcalc/code;
    rev = "db5c5d587d4d24ff6b23405a92eeaad4c0f99618";
    sha256 = "1bzmiz9rrss3xk0vzszbisjkph73zwgc0riqn9zdd2h1iv6dgq92";
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
