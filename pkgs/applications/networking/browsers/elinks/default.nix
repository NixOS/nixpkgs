args: with args;

stdenv.mkDerivation {
  name = "elinks-0.11.3";

  src = fetchurl {
    url = http://elinks.or.cz/download/elinks-0.11.3.tar.bz2;
    sha256 = "c10e657fbd884eae4f01b91b32407bbfcbcae0ad5017fb24ea365aebc71d2af1";
  };

  buildInputs = [python perl ncurses x11 bzip2 zlib openssl spidermonkey guile gpm];
  configureFlags = "--enable-finger --enable-html-highlight --with-guile
  --with-perl --with-python --enable-gopher --enable-cgi --enable-bittorrent
  --enable-nntp --with-openssl=${openssl}";

  meta = {
    description = "Full-Featured Text WWW Browser";
    homepage = http://elinks.or.cz;
  };
}
