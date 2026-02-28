{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gbenchmark,
  gtest,
  simdjson,
  simdutf,
  testers,
  validatePkgConfig,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ada";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+aXZY6JFfbw1N+EkenPhfp6ErUJFnbiJsgHpQq36Os4=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [ simdutf ];

  doCheck = true;
  checkInputs = [
    simdjson
    gtest
    gbenchmark
  ];

  cmakeFlags = [
    # uses CPM that requires network access
    (lib.cmakeBool "ADA_TOOLS" false)
    (lib.cmakeBool "ADA_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ADA_USE_SIMDUTF" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES" true)
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "WHATWG-compliant and fast URL parser written in modern C";
    homepage = "https://github.com/ada-url/ada";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "ada" ];
  };
})
