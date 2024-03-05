{ lib, stdenv, rustPlatform, fetchFromGitHub, stfl, sqlite, curl, gettext, pkg-config, libxml2, json_c, ncurses
, asciidoctor, libiconv, Security, Foundation, makeWrapper, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.34";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    hash = "sha256-knF+N/HHL/E6C973t+ww5XTLV2thwy7lMAeqTyXspHY=";
  };

  cargoHash = "sha256-IsDym+tqF040SxCJF575OPm45IROYMFsCrxJcM1SAJ4=";

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
    make -j $NIX_BUILD_CORES prefix="$out"
  '';

  # https://github.com/NixOS/nixpkgs/pull/98471#issuecomment-703100014 . We set
  # these for all platforms, since upstream's gettext crate behavior might
  # change in the future.
  GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
  GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";

  doCheck = true;

  preCheck = ''
    make -j $NIX_BUILD_CORES test
  '';

  postInstall = ''
    make -j $NIX_BUILD_CORES prefix="$out" install
  '' + lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage    = "https://newsboat.org/";
    changelog   = "https://github.com/newsboat/newsboat/blob/${src.rev}/CHANGELOG.md";
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with lib.maintainers; [ dotlambda nicknovitski ];
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
  };
}
