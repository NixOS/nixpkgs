{ stdenv, rustPlatform, fetchurl, fetchpatch, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "newsboat-${version}";
  version = "2.14.1";

  src = fetchurl {
    url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
    sha256 = "0rnz61in715xgma6phvmn5bil618gic01f3kxzhcfgqsj2qx7l2b";
  };

  cargoSha256 = "05pf020jp20ffmvin6d1g8zbwf1zk03bm1cb99b7iqkk4r54g6dn";

  cargoPatches = [
    # Bump versions in Cargo.lock
    (fetchpatch {
      url = https://github.com/newsboat/newsboat/commit/cbad27a19d270f2f0fce9317651e2c9f0aa22865.patch;
      sha256 = "05n31b6mycsmzilz7f3inkmav34210c4nlr1fna4zapbhxjdlhqn";
    })
  ];

  postPatch = ''
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
