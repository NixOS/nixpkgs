{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "vbindiff-${version}";
  version = "3.0_beta4";

  buildInputs = [ ncurses ];

  src = fetchurl {
    url = "http://www.cjmweb.net/vbindiff/${name}.tar.gz";
    sha256 = "0gcqy4ggp60qc6blq1q1gc90xmhip1m6yvvli4hdqlz9zn3mlpbx";
  };

  meta = {
    description = "A terminal visual binary diff viewer";
    homepage = "http://www.cjmweb.net/vbindiff/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
