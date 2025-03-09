{
  lib,
  stdenv,
  fetchgit,
  cmake,
  zlib,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "avy";
  version = "2019.05.01"; # date of cav19 tag

  src = fetchgit {
    url = "https://bitbucket.org/arieg/extavy";
    rev = "cav19";
    sha256 = "0qdzy9srxp5f38x4dbb3prnr9il6cy0kz80avrvd7fxqzy7wdlwy";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    boost.out
    boost.dev
  ];
  env.NIX_CFLAGS_COMPILE = toString (
    [ "-Wno-narrowing" ]
    # Squelch endless stream of warnings on same few things
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-empty-body"
      "-Wno-tautological-compare"
      "-Wc++11-compat-deprecated-writable-strings"
      "-Wno-deprecated"
    ]
  );

  prePatch = ''
    sed -i -e '1i#include <stdint.h>' abc/src/bdd/dsd/dsd.h
    substituteInPlace abc/src/bdd/dsd/dsd.h --replace \
               '((Child = Dsd_NodeReadDec(Node,Index))>=0);' \
               '((intptr_t)(Child = Dsd_NodeReadDec(Node,Index))>=0);'

    patch -p1 -d minisat -i ${./minisat-fenv.patch}
    patch -p1 -d glucose -i ${./glucose-fenv.patch}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp avy/src/{avy,avybmc} $out/bin/
  '';

  meta = {
    description = "AIGER model checking for Property Directed Reachability";
    homepage = "https://arieg.bitbucket.io/avy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.linux;
  };
}
