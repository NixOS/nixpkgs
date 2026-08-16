{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  withAbseil ? false,
  abseil-cpp,
  re2,
  # Enable C++17 support
  #     https://github.com/google/googletest/issues/3081
  # Projects that require a higher standard can override this package.
  # For an example why that may be necessary, see:
  #     https://github.com/mhx/dwarfs/issues/188#issuecomment-1907574427
  # Setting this to `null` does not pass any flags to set this.
  cxx_standard ? (
    if
      (
        (stdenv.cc.isGNU && (lib.versionOlder stdenv.cc.version "11.0"))
        || (stdenv.cc.isClang && (lib.versionOlder stdenv.cc.version "16.0"))
      )
    then
      "17"
    else
      null
  ),
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtest";
  version = "1.18.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rXsn2L0xeWvfxTjMAoWEu0UFZ7xOSfYmhbKgRF5J9co=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals withAbseil [
    abseil-cpp
    re2
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
  ]
  ++ lib.optionals (cxx_standard != null) [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" cxx_standard)
  ]
  ++ lib.optional withAbseil (lib.cmakeBool "GTEST_HAS_ABSL" true);

  __structuredAttrs = true;

  meta = {
    description = "Google's framework for writing C++ tests";
    homepage = "https://github.com/google/googletest";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
