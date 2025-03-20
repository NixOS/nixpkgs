{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  tbb_2022_0,
  useTBB ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    tag = finalAttrs.version;
    hash = "sha256-08D5hnU3I0VJ+RM/TNk2LxsEAvOLuO52+08zlKssXbc=";
  };

  sourceRoot = finalAttrs.src.name + "/c";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals useTBB [ tbb_2022_0 ];

  cmakeFlags = [
    (lib.cmakeBool "BLAKE3_USE_TBB" useTBB)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Official C implementation of BLAKE3";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/tree/master/c";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [
      fgaz
      silvanshade
    ];
    platforms = lib.platforms.all;
  };
})
