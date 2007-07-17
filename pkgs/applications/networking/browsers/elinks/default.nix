{stdenv, fetchurl, python, perl, ncurses, x11, zlib, openssl}:

stdenv.mkDerivation {
  name = "elinks-0.11.3";

  src = fetchurl {
    url = http://elinks.or.cz/download/elinks-0.11.3.tar.bz2;
    sha256 = "c10e657fbd884eae4f01b91b32407bbfcbcae0ad5017fb24ea365aebc71d2af1";
  };

  buildInputs = [ python perl ncurses x11 zlib openssl ];
  configureFlags = "--with-perl --with-python";
  meta = {
	  description = "Full-Featured Text WWW Browser";
	  homepage = http://elinks.or.cz;
  };
}
