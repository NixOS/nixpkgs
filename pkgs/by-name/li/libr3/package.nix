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
    pcre2
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "High-performance path dispatching library";
    homepage = "https://github.com/c9s/r3";
    license = [ lib.licenses.mit ];
    pkgConfigModules = [
      "r3"
    ];
  };
})
