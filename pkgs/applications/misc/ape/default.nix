{ stdenv, swiProlog, makeWrapper,
  fetchFromGitHub,
  lexicon ? "lexicon/clex_lexicon.pl",
  pname ? "ape",
  description ? "Parser for Attempto Controlled English (ACE)",
  license ? with stdenv.lib; licenses.lgpl3
  }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "6.7-131003";

  buildInputs = [ swiProlog makeWrapper ];

  src = fetchFromGitHub {
     owner = "Attempto";
     repo = "APE";
     rev = version;
     sha256 = "0cw47qjg4896kw3vps6rfs02asvscsqvcfdiwgfmqb3hvykb1sdx";
  };

  patchPhase = ''
    # We move the file first to avoid "same file" error in the default case
    cp ${lexicon} new_lexicon.pl
    rm lexicon/clex_lexicon.pl
    cp new_lexicon.pl lexicon/clex_lexicon.pl
  '';

  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ape.exe $out
    makeWrapper $out/ape.exe $out/bin/ape --add-flags ace
  '';

  meta = with stdenv.lib; {
    description = description;
    license = license;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk ];
  };
}
