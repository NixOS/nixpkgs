{
  lib,
  stdenv,
  fetchgit,
  cmake,
  zlib,
  boost,
}:

stdenv.mkDerivation {
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

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.5.1)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace abc/CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8.6)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace {avy,muser2,glucose,minisat}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.6)" "cmake_minimum_required (VERSION 3.10)"

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
