{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  spdlog,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catch2";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T7Wd3Fq2YwjXU7hKm0ej/CIXQtrorPr6qALzfF4UwJU=";
  };

  postPatch = ''
    substituteInPlace CMake/*.pc.in \
      --replace-fail "\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  hardeningDisable = [ "trivialautovarinit" ];

  cmakeFlags = [
    (lib.cmakeBool "CATCH_DEVELOPMENT_BUILD" true)
    (lib.cmakeBool "CATCH_BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "CATCH_ENABLE_WERROR" false)
  ]
  ++ lib.optionals (stdenv.cc.isClang && finalAttrs.doCheck) [
    # test has a faulty path normalization technique that won't work in
    # our darwin/LLVM build environment https://github.com/catchorg/Catch2/issues/1691
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "-E;ApprovalTests")
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString (
      lib.optionals stdenv.hostPlatform.isx86_32 [
        # Tests fail on x86_32 if compiled with x87 floats: https://github.com/catchorg/Catch2/issues/2796
        "-msse2"
        "-mfpmath=sse"
      ]
      ++ lib.optionals (stdenv.hostPlatform.isRiscV || stdenv.hostPlatform.isAarch32) [
        # Build failure caused by -Werror: https://github.com/catchorg/Catch2/issues/2808
        "-Wno-error=cast-align"
      ]
    );
  };

  doCheck = true;

  nativeCheckInputs = [
    python3
  ];

  passthru.tests = {
    inherit spdlog;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  __structuredAttrs = true;

  meta = {
    description = "Modern, C++-native, test framework for unit-tests";
    homepage = "https://github.com/catchorg/Catch2";
    changelog = "https://github.com/catchorg/Catch2/blob/${finalAttrs.src.tag}/docs/release-notes.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = with lib.platforms; unix ++ windows;
    pkgConfigModules = [
      "catch2"
      "catch2-with-main"
    ];
  };
})
