{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  spdlog,
}:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    tag = "v${version}";
    hash = "sha256-7Dx7PhtRwkbo8vHF57sAns2fQZ442D3cMyCt25RvzJc=";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # This test fails to compile with Clang 20
    # See: https://github.com/catchorg/Catch2/issues/2991
    ./clang-20-disable-broken-test.patch
  ];

  postPatch = ''
    substituteInPlace CMake/*.pc.in \
      --replace-fail "\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  hardeningDisable = [ "trivialautovarinit" ];

  cmakeFlags = [
    "-DCATCH_DEVELOPMENT_BUILD=ON"
    "-DCATCH_BUILD_TESTING=${if doCheck then "ON" else "OFF"}"
    "-DCATCH_ENABLE_WERROR=OFF"
  ]
  ++ lib.optionals (stdenv.cc.isClang && doCheck) [
    # test has a faulty path normalization technique that won't work in
    # our darwin/LLVM build environment https://github.com/catchorg/Catch2/issues/1691
    "-DCMAKE_CTEST_ARGUMENTS=-E;ApprovalTests"
  ];

  env =
    lib.optionalAttrs stdenv.hostPlatform.isx86_32 {
      # Tests fail on x86_32 if compiled with x87 floats: https://github.com/catchorg/Catch2/issues/2796
      NIX_CFLAGS_COMPILE = "-msse2 -mfpmath=sse";
    }
    // lib.optionalAttrs (stdenv.hostPlatform.isRiscV || stdenv.hostPlatform.isAarch32) {
      # Build failure caused by -Werror: https://github.com/catchorg/Catch2/issues/2808
      NIX_CFLAGS_COMPILE = "-Wno-error=cast-align";
    };

  doCheck = true;

  nativeCheckInputs = [
    python3
  ];

  passthru.tests = {
    inherit spdlog;
  };

  meta = {
    description = "Modern, C++-native, test framework for unit-tests";
    homepage = "https://github.com/catchorg/Catch2";
    changelog = "https://github.com/catchorg/Catch2/blob/${src.tag}/docs/release-notes.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
