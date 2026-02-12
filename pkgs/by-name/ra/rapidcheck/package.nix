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
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo = "rapidcheck";
    rev = "b96a4e626ef4c7348dcd16c500353c2f997a9f3f";
    hash = "sha256-h7Q1Lczqsrifwl5w9TDAlDjJhbroc1W4O3icLRvZwaM=";
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
