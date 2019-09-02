{ stdenv, rustPlatform, fetchurl, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "newsboat-${version}";
  version = "2.16.1";

  src = fetchurl {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "0lxdsfcwa4byhfnn0gv34w3rr531f4nfqgi8j4qqmh3gncbwh8s0";
  };

  cargoSha256 = "0ck2dgfk4fay4cjl66wqkbnq4rqrd717jl63l1mvqmvad9i19igm";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xsl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-error=sign-compare" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-Wno-error=format-security";

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
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
