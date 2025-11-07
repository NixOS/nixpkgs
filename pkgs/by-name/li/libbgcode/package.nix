{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  heatshrink,
  zlib,
  boost,
  catch2_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libbgcode";
  version = "0-unstable-2025-02-19";

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "libbgcode";
    rev = "5041c093b33e2748e76d6b326f2251310823f3df";
    hash = "sha256-EaxVZerH2v8b1Yqk+RW/r3BvnJvrAelkKf8Bd+EHbEc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    heatshrink
    zlib
    boost
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "LibBGCode_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  meta = with lib; {
    homepage = "https://github.com/prusa3d/libbgcode";
    description = "Prusa Block & Binary G-code reader / writer / converter";
    mainProgram = "bgcode";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ lach ];
    platforms = platforms.unix;
  };
})
