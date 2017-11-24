{ stdenv, fetchzip, sqlite, curl, pkgconfig, libxml2, stfl, json-c-0-11, ncurses
, gettext, asciidoc, docbook_xml_xslt, libiconv, makeWrapper, perl, fetchpatch }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "newsboat";
  version = "2.10.1";

  src = fetchzip {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "019bm8j9vbpj39vs6xhrj34cd9ipjyqpwkl5psaks2w6g7wzyp1p";
  };

  buildInputs
    = [ pkgconfig sqlite curl libxml2 stfl json-c-0-11 ncurses gettext
        asciidoc docbook_xml_xslt libiconv ]
      ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  postPatch = ''
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
    substituteInPlace ./Makefile \
      --replace "a2x" "${asciidoc}/bin/a2x --no-xmllint"
  '';

  preBuild = ''
    sed -i -e 107,112d config.sh
    sed -i "1 s%^.*$%#!${perl}/bin/perl%" txt2h.pl
    export LDFLAGS=-lncursesw
  '';

  installFlags = [ "DESTDIR=$(out)" "prefix=" ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    cp -r $src/contrib $out
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://newsboat.org/;
    description = "An open-source RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ nicknovitski tasmo ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
