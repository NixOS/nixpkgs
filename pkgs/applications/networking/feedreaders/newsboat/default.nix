{ lib, stdenv, rustPlatform, fetchFromGitHub, stfl, sqlite, curl, gettext, pkg-config, libxml2, json_c, ncurses
, asciidoctor, libiconv, Security, Foundation, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.25";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    sha256 = "sha256-TAnGDxTKYl4niouS6nYdJDaIngAPsPHr9Bw9L3cR2Xk=";
  };

  cargoSha256 = "sha256-MxoyYBLbrCuLVa0p8JrYKSKu2oFPnXMwab42lhhAu48=";

  # TODO: Check if that's still needed
  postPatch = lib.optionalString stdenv.isDarwin ''
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    gettext
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ncurses ];

  buildInputs = [ stfl sqlite curl libxml2 json_c ncurses ]
    ++ lib.optionals stdenv.isDarwin [ Security Foundation libiconv gettext ];

  postBuild = ''
    make prefix="$out"
  '';

  # TODO: Check if that's still needed
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin " -Wno-error=format-security";

  # https://github.com/NixOS/nixpkgs/pull/98471#issuecomment-703100014 . We set
  # these for all platforms, since upstream's gettext crate behavior might
  # change in the future.
  GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
  GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";

  doCheck = true;

  preCheck = ''
    make test
  '';

  postInstall = ''
    make prefix="$out" install
    cp -r contrib $out
  '' + lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with lib; {
    homepage    = "https://newsboat.org/";
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
