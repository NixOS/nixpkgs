{ stdenv, fetchurl, sqlite, curl, pkgconfig, libxml2, stfl, json_c, ncurses
, gettext, libiconvOrEmpty, makeWrapper, perl }:

stdenv.mkDerivation rec {
  name = "newsbeuter-2.7";

  src = fetchurl {
    url = "http://www.newsbeuter.org/downloads/${name}.tar.gz";
    sha256 = "0flhzzlbdirjmrq738gmcxqqnifg3kb7plcwqcxshpizmjkhswp6";
  };

  buildInputs
    # use gettext instead of libintlOrEmpty so we have access to the msgfmt
    # command
    = [ pkgconfig sqlite curl libxml2 stfl json_c ncurses gettext perl ]
      ++ libiconvOrEmpty
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  preBuild = ''
    sed -i -e 104,108d config.sh
    sed -i "1 s%^.*$%#!${perl}/bin/perl%" txt2h.pl
    export LDFLAGS=-lncursesw
  '';

  installPhase = ''
    DESTDIR=$out prefix=\"\" make install
  ''
    + stdenv.lib.optionalString stdenv.isDarwin ''
      for prog in $out/bin/*; do
        wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
      done
    '';

  meta = {
    homepage    = http://www.newsbeuter.org;
    description = "An open-source RSS/Atom feed reader for text terminals";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
  };
}

