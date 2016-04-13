{ stdenv, fetchurl, sqlite, curl, pkgconfig, libxml2, stfl, json-c-0-11, ncurses
, gettext, libiconv, makeWrapper, perl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "newsbeuter-2.9";

  src = fetchurl {
    url = "http://www.newsbeuter.org/downloads/${name}.tar.gz";
    sha256 = "1j1x0hgwxz11dckk81ncalgylj5y5fgw5bcmp9qb5hq9kc0vza3l";

  };

  buildInputs
    # use gettext instead of libintlOrEmpty so we have access to the msgfmt
    # command
    = [ pkgconfig sqlite curl libxml2 stfl json-c-0-11 ncurses gettext perl libiconv ]
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  preBuild = ''
    sed -i -e 110,114d config.sh
    sed -i "1 s%^.*$%#!${perl}/bin/perl%" txt2h.pl
    export LDFLAGS=-lncursesw
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/akrennmair/newsbeuter/commit/cdacfbde9fe3ae2489fc96d35dfb7d263ab03f50.patch";
      sha256 = "1lhvn63cqjpikwsr6zzndb1p5y140vvphlg85fazwx4xpzd856d9";
    })
  ];

  installFlags = [ "DESTDIR=$(out)" "prefix=" ];

  installPhase = stdenv.lib.optionalString stdenv.isDarwin ''
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
