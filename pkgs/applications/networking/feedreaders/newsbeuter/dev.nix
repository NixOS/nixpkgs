{ stdenv, fetchgit, sqlite, curl, pkgconfig, libxml2, stfl, json-c-0-11, ncurses
, gettext, libiconvOrEmpty, makeWrapper, perl }:

stdenv.mkDerivation rec {
  name = "newsbeuter-dev-20140309";

  src = fetchgit {
    url = "https://github.com/akrennmair/newsbeuter.git";
    rev = "1427bdb0705806368db39576a9b803df82fa0415";
    sha256 = "b29a304a46bf56b439d0d35ea586f7fd0fbf1a5565dca95de76e774885d8b64b";
  };

  buildInputs
    # use gettext instead of libintlOrEmpty so we have access to the msgfmt
    # command
    = [ pkgconfig sqlite curl libxml2 stfl json-c-0-11 ncurses gettext perl ]
      ++ libiconvOrEmpty
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  preBuild = ''
    sed -i -e 110,114d config.sh
    sed -i "1 s%^.*$%#!${perl}/bin/perl%" txt2h.pl
    export LDFLAGS=-lncursesw
  '';

  NIX_CFLAGS_COMPILE =
    "-I${libxml2}/include/libxml2 -I${json-c-0-11}/include/json-c";

  NIX_LDFLAGS = "-lsqlite3 -lcurl -lxml2 -lstfl -ljson";

  installPhase = ''
    DESTDIR=$out prefix=\"\" make install
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.newsbeuter.org;
    description = "An open-source RSS/Atom feed reader for text terminals";
    maintainers = with maintainers; [ lovek323 ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
