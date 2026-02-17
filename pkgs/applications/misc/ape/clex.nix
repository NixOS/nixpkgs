{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "attempto-clex";
  version = "6.5-090528";

  src = fetchFromGitHub {
    owner = "Attempto";
    repo = "Clex";
    tag = version;
    hash = "sha256-Oa1AMBaYpjd+U2k9lBnou4+4IgBwU8fojJ8bY9tf9ZE=";
  };

  installPhase = ''
    mkdir -p $out
    cp clex_lexicon.pl $out
  '';

  meta = {
    description = "Large lexicon for APE (~100,000 entries)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yrashk ];
  };
}
