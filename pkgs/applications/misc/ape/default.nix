{
  lib,
  stdenv,
  swiProlog,
  makeWrapper,
  fetchFromGitHub,
  lexiconPath ? "prolog/lexicon/clex_lexicon.pl",
  pname ? "ape",
  description ? "Parser for Attempto Controlled English (ACE)",
  license ? with lib; licenses.lgpl3,
}:

stdenv.mkDerivation rec {
  inherit pname;
  version = "2019-08-10";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ swiProlog ];

  src = fetchFromGitHub {
    owner = "Attempto";
    repo = "APE";
    rev = "113b81621262d7a395779465cb09397183e6f74c";
    sha256 = "0xyvna2fbr18hi5yvm0zwh77q02dfna1g4g53z9mn2rmlfn2mhjh";
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

  meta = with lib; {
    description = description;
    license = license;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk ];
    mainProgram = "ape";
  };
}
