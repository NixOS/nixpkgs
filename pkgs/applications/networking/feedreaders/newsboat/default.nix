{ stdenv, fetchurl, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xml_xslt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "newsboat-${version}";
  version = "2.10.2";

  src = fetchurl {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "1x4nxx1kvmrcm8jy73dvg56h4z15y3sach2vr13cw8rsbi7v99px";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "|| true" ""
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xml_xslt ]
                      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ];

  installFlags = [ "DESTDIR=$(out)" "prefix=" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://newsboat.org/;
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console.";
    maintainers = with maintainers; [ dotlambda ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
