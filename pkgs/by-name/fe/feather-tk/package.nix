{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  python3,
  freetype,
  glfw,
  gtk3,
  libGL,
  libpng,
  lunasvg,
  nlohmann_json,
  plutovg,
  xorg,
  zlib,
  nativeFileDialog ? null,
  python3Packages ? null,
  enableNFD ? false,
  enablePython ? false,
  enableTests ? false,
  enableExamples ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feather-tk";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "darbyjohnston";
    repo = "feather-tk";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-776V1nMsAatGkYNBq7QFRX28cI3/NU/2YRSbhfezr0g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    freetype
    glfw
    lunasvg
    plutovg
    nlohmann_json
    libpng
    zlib
    libGL
  ]
  ++ lib.optionals (enableNFD && nativeFileDialog != null) [
    nativeFileDialog
  ]
  ++ lib.optionals (enableNFD && stdenv.isLinux) [
    gtk3
  ]
  ++ lib.optionals enablePython [
    python3Packages.pybind11
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "feather_tk_UI_LIB" true)
    (lib.cmakeFeature "feather_tk_API" "GL_4_1")
    (lib.cmakeBool "feather_tk_nfd" enableNFD)
    (lib.cmakeBool "feather_tk_PYTHON" enablePython)
    (lib.cmakeBool "feather_tk_TESTS" enableTests)
    (lib.cmakeBool "feather_tk_EXAMPLES" enableExamples)
    (lib.cmakeFeature "feather_tk_BUILD" "default")
  ];

  doCheck = enableTests;

  nativeCheckInputs = lib.optionals (enableTests && stdenv.isLinux) [
    xorg.xvfb-run
  ];

  checkPhase = lib.optionalString enableTests ''
    runHook preCheck

    cd feather-tk/src/feather-tk-build
    ${if stdenv.isLinux then "xvfb-run" else ""} ctest --verbose -C Release

    runHook postCheck
  '';

  meta = {
    description = "Lightweight toolkit for building cross-platform applications";
    homepage = "https://github.com/darbyjohnston/feather-tk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
