{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcheck";
  version = "0-unstable-2026-10-05";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo = "rapidcheck";
    rev = "2c3c4365aca21ef4e612768fdc95b1ce8b39a651";
    hash = "sha256-kfiDY6OjXt9C1EOdyHOfnSbaRP/ncNdoN6hKlVTRXJQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "RC_INSTALL_ALL_EXTRAS" true)
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "C++ framework for property based testing inspired by QuickCheck";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = [ ];
    license = lib.licenses.bsd2;
    pkgConfigModules = [
      "rapidcheck"
      # Extras
      "rapidcheck_boost"
      "rapidcheck_boost_test"
      "rapidcheck_catch"
      "rapidcheck_doctest"
      "rapidcheck_gtest"
    ];
    platforms = lib.platforms.all;
  };
})
