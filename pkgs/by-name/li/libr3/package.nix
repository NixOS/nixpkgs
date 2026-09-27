{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
  pkg-config,
  check,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libr3";
  version = "2.0.0-unstable-2025-11-24";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "c9s";
    repo = "r3";
    rev = "b07a1d4dfe02766f104307ec8f00bb74c549bdd4";
    hash = "sha256-qsnkzciPuBoz2ZJWQUEjieBIY5ix2coFTJaGtDBH6uo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    check
  ];

  propagatedBuildInputs = [
    # $out/lib/pkgconfig/r3.pc uses flags `Libs: -L${libdir} -lr3`
    # $out/include/r3/r3.h has an include `#include <pcre2.h>`
    # This makes it impossible to use libr3 without also linking to pcre2, requiring pcre2 to be propagated to consumers.
    pcre2
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  passthru.tests.consumer = stdenv.mkDerivation (consumerAttrs: {
    pname = "libr3-test";
    inherit (finalAttrs) version src;
    sourceRoot = "${consumerAttrs.src.name}/examples";

    buildInputs = [ finalAttrs.finalPackage ];
    nativeBuildInputs = [ pkg-config ];

    doCheck = true;

    buildPhase = "cc simple.c -o test `pkg-config --cflags --libs r3`";
    checkPhase = "./test";
    installPhase = "mkdir -p $out/bin; mv test $out/bin/";
  });

  meta = {
    description = "High-performance path dispatching library";
    homepage = "https://github.com/c9s/r3";
    license = lib.licenses.mit;
    pkgConfigModules = [
      "r3"
    ];
  };
})
