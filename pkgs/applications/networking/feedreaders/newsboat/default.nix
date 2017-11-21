{ stdenv, fetchurl, sqlite, curl, pkgconfig, libxml2, stfl, json-c-0-11, ncurses
, gettext, asciidoc, docbook_xml_xslt, libiconv, makeWrapper, perl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "newsboat";
  version = "r2.10.1";

  src = fetchurl {
    url = "https://github.com/newsboat/${pname}/archive/${version}.tar.gz";
    sha256 = "82d5e3e2a6dab845aac0bf72580f46c2756375d49214905a627284e5bc32e327";
  };

  outputs = [ "out" "doc" ];

  buildInputs
    = [ pkgconfig sqlite curl libxml2 stfl json-c-0-11 ncurses gettext asciidoc docbook_xml_xslt libiconv ]
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  preBuild = ''
    sed -i -e 107,112d config.sh
    sed -i "1 s%^.*$%#!${perl}/bin/perl%" txt2h.pl
    export LDFLAGS=-lncursesw
  '';

  installFlags = [ "DESTDIR=$(out)" "prefix=" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = {
    homepage    = https://newsboat.org/;
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console. The only difference is that Newsboat is actively maintained while Newsbeuter isn't";
    maintainers = with stdenv.lib.maintainers; [ tasmo ];
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
  };
}
