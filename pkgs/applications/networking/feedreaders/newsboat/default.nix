{ stdenv, fetchurl, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xml_xslt, libiconv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "newsboat-${version}";
  version = "2.11.1";

  src = fetchurl {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "1krpxl854h5dwmpr81m1s84cwk8zivdzvw0s5s0i4dba736pvdma";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xml_xslt ]
                      ++ stdenv.lib.optional stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ];

  makeFlags = [ "prefix=$(out)" ];

  doCheck = true;
  checkTarget = "test";

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  postInstall = ''
    cp -r contrib $out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://newsboat.org/;
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console.";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
