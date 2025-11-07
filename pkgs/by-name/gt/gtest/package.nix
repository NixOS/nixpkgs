{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
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

stdenv.mkDerivation rec {
  pname = "gtest";
  version = "1.17.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v${version}";
    hash = "sha256-HIHMxAUR4bjmFLoltJeIAVSulVQ6kVuIT2Ku+lwAx/4=";
  };

  patches = [
    ./fix-cmake-config-includedir.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ]
  ++ lib.optionals (cxx_standard != null) [
    "-DCMAKE_CXX_STANDARD=${cxx_standard}"
  ];

  meta = with lib; {
    description = "Google's framework for writing C++ tests";
    homepage = "https://github.com/google/googletest";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
