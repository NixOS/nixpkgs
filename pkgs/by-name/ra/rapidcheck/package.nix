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
  version = "0-unstable-2026-04-25";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo = "rapidcheck";
    rev = "b2d9ed2dddefc4b84318d664b4f221eb792d89c7";
    hash = "sha256-AOHG06EVsOOdvyOohP5hsFuEe7yfXuvkEgFHQUVUs0w=";
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
