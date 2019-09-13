{ stdenv, swiProlog, makeWrapper,
  fetchFromGitHub,
  lexicon ? "lexicon/clex_lexicon.pl",
  pname ? "ape",
  description ? "Parser for Attempto Controlled English (ACE)",
  license ? with stdenv.lib; licenses.lgpl3
  }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "6.7.180715";

  buildInputs = [ swiProlog makeWrapper ];

  src = fetchFromGitHub {
     owner = "Attempto";
     repo = "APE";
     rev = version;
     sha256 = "1jnr6y4kc6d5rjy6bbbnn4n7rl6ajpvw4xf4067wjh28c9scjwg3";
  };

  patchPhase = ''
    # don't try to force /bin/bash
    sed -i '/SHELL=\/bin\/bash/d' Makefile
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
