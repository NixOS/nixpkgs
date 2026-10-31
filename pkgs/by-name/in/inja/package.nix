{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nlohmann_json,
  doctest,
  callPackage,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inja";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "pantor";
    repo = "inja";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P4XKz2FcMfP0HRMoEC2+RKE/ljZSpusUTDmF9Ao5txo=";
  };

  patches = [
    # https://github.com/pantor/inja/pull/317
    (fetchpatch {
      name = "cmake-install-pc.patch";
      url = "https://github.com/pantor/inja/commit/ebb7aeb3ae49ccb49a642aaecb0d41483078b8bd.patch";
      hash = "sha256-Cz0EbYwGwFcfhKd8lJzXDy2DpMAcHkz7EC/vVFV60c0=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ nlohmann_json ];

  cmakeFlags = [
    (lib.cmakeBool "INJA_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "INJA_USE_EMBEDDED_JSON" false)
    (lib.cmakeBool "BUILD_BENCHMARK" false)
  ];

  checkInputs = [ doctest ];
  doCheck = true;

  passthru.tests = {
    simple-cmake = callPackage ./simple-cmake-test { };
  };

  meta = {
    changelog = "https://github.com/pantor/inja/releases/tag/v${finalAttrs.version}";
    description = "Template engine for modern C++, loosely inspired by jinja for python";
    homepage = "https://github.com/pantor/inja";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xokdvium ];
    platforms = lib.platforms.all;
  };
})
