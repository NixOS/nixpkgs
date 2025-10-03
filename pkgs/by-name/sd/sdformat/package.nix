{
  lib,
  stdenv,
  fetchFromGitHub,
  cli11,
  cmake,
  pkg-config,
  tinyxml-2,
  urdfdom,
  boost,
  libuuid,
  doxygen,
  gz-cmake,
  python3Full,
  gz-utils,
  gz-math,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdformat";
  version = "15.3.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "sdformat";
    tag = "sdformat${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-5EGAypmWiUHvGpAXTIWJi8ChWkafK1li1C0/C1GIfkA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gz-cmake
    python3Full
    gz-utils
    gz-math
  ];

  buildInputs = [
    boost
    cli11
    doxygen
    libuuid
    tinyxml-2
    urdfdom
  ];

  cmakeFlags = [
    "-DUSE_INTERNAL_URDF=ON"
    "-DBUILD_TESTING=ON"
  ];

  meta = {
    description = "Simulation Description Format (SDF) parser and description files";
    homepage = "http://sdformat.org/";
    downloadPage = "https://github.com/gazebosim/sdformat";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
