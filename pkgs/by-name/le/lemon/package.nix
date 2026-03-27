{
  lib,
  stdenv,
  fetchurl,
}:

let

  srcs = {
    lemon = fetchurl {
      hash = "sha256-TXVOEtRpOhLCyi4C3RMt0lHmMp/y2K5YdL8ND6WPrOY=";
      url = "https://www.sqlite.org/src/raw/3fdc16b23f1ea0c91c049b518fc3f75c71843dbfe2b447fcb3cd92d9e4f219f8?at=lemon.c";
      name = "lemon.c";
    };
    lempar = fetchurl {
      hash = "sha256-TYKrUJHtpoljeRWZq4Y1rYLlu7LeM/HuUhe3LJZZkVo=";
      url = "https://www.sqlite.org/src/raw/b57e1780bf8098dd4a9a5bba537f994276ea825a420f6165153e5894dc2dfb07?at=lempar.c";
      name = "lempar.c";
    };
  };

in
stdenv.mkDerivation {
  pname = "lemon";
  version = "1.0-unstable";

  dontUnpack = true;

  buildPhase = ''
    sh -xc "$CC ${srcs.lemon} -o lemon"
  '';

  installPhase = ''
    install -Dvm755 lemon $out/bin/lemon
    install -Dvm644 ${srcs.lempar} $out/bin/lempar.c
  '';

  meta = {
    description = "LALR(1) parser generator";
    mainProgram = "lemon";
    longDescription = ''
      The Lemon program is an LALR(1) parser generator that takes a
      context-free grammar and converts it into a subroutine that will parse a
      file using that grammar. Lemon is similar to the much more famous
      programs "yacc" and "bison", but is not compatible with either.
    '';
    homepage = "http://www.hwaci.com/sw/lemon/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
}
