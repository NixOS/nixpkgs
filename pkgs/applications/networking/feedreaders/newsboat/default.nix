{ stdenv, rustPlatform, fetchurl, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "newsboat-${version}";
  version = "2.14";

  src = fetchurl {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "13bdwnwxa66c69lqhb02basff0aa6q1jhl7fgahcxmdy7snbmg37";
  };

  cargoSha256 = "11s50qy1b833r2b5kr1wx9imi9h7s00c0hs36ricgbd0xw7n76hd";

  prePatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xsl ]
    ++ stdenv.lib.optional stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  doCheck = true;

  checkPhase = ''
    make test
  '';

  postInstall = ''
    make prefix="$out" install
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
