{
  lib,
  stdenv,
  swi-prolog,
  makeWrapper,
  fetchFromGitHub,
  lexiconPath ? "prolog/lexicon/clex_lexicon.pl",
  pname ? "ape",
  description ? "Parser for Attempto Controlled English (ACE)",
  license ? lib.licenses.lgpl3,
}:

stdenv.mkDerivation {
  inherit pname;
  version = "2019-08-10";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ swi-prolog ];

  src = fetchFromGitHub {
    owner = "Attempto";
    repo = "APE";
    rev = "113b81621262d7a395779465cb09397183e6f74c";
    hash = "sha256-UMIqrKM1C1vTH+WRF5R1TQB8DuQf1O1LhCjk5YSy23c=";
  };

  patchPhase = ''
    # We move the file first to avoid "same file" error in the default case
    cp ${lexiconPath} new_lexicon.pl
    rm prolog/lexicon/clex_lexicon.pl
    cp new_lexicon.pl prolog/lexicon/clex_lexicon.pl
  '';

  buildPhase = ''
    make SHELL=${stdenv.shell} build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ape.exe $out
    makeWrapper $out/ape.exe $out/bin/ape --add-flags ace
  '';

  meta = {
    description = description;
    homepage = "https://github.com/Attempto/APE";
    license = license;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yrashk ];
    mainProgram = "ape";
  };
}
