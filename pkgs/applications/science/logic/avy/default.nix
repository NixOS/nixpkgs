{ stdenv, fetchgit, cmake, zlib, boost }:

stdenv.mkDerivation rec {
  name = "avy-${version}";
  version = "2017.10.16";

  src = fetchgit {
    url    = "https://bitbucket.org/arieg/extavy";
    rev    = "c75c83379c38d6ea1046d0caee95aef77283ffe3";
    sha256 = "0zcycnypg4q5g710bnkjpycaawmibc092vmyhgfbixkgq9fb5lfh";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake zlib boost.out boost.dev ];
  NIX_CFLAGS_COMPILE = [ "-Wno-narrowing" ]
    # Squelch endless stream of warnings on same few things
    ++ stdenv.lib.optionals stdenv.cc.isClang [
      "-Wno-empty-body"
      "-Wno-tautological-compare"
      "-Wc++11-compat-deprecated-writable-strings"
      "-Wno-deprecated"
    ];

  prePatch = ''
    sed -i -e '1i#include <stdint.h>' abc/src/bdd/dsd/dsd.h
    substituteInPlace abc/src/bdd/dsd/dsd.h --replace \
               '((Child = Dsd_NodeReadDec(Node,Index))>=0);' \
               '((intptr_t)(Child = Dsd_NodeReadDec(Node,Index))>=0);'

    patch -p1 -d minisat -i ${./minisat-fenv.patch}
    patch -p1 -d glucose -i ${./glucose-fenv.patch}
  '';

  patches =
    [ ./0001-no-static-boost-libs.patch
    ];

  installPhase = ''
    mkdir -p $out/bin
    cp avy/src/{avy,avybmc} $out/bin/
  '';

  meta = {
    description = "AIGER model checking for Property Directed Reachability";
    homepage    = https://arieg.bitbucket.io/avy/;
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
