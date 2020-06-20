{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "vbindiff";
  version = "3.0_beta5";

  buildInputs = [ ncurses ];

  src = fetchurl {
    url = "https://www.cjmweb.net/vbindiff/${pname}-${version}.tar.gz";
    sha256 = "1f1kj4jki08bnrwpzi663mjfkrx4wnfpzdfwd2qgijlkx5ysjkgh";
  };

  meta = {
    description = "A terminal visual binary diff viewer";
    homepage = "https://www.cjmweb.net/vbindiff/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
