{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  onetbb,

  useTBB ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.8.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    tag = finalAttrs.version;
    hash = "sha256-IABVErXWYQFXZcwsFKfQhm3ox7UZUcW5uzVrGwsSp94=";
  };

  patches = [
    # build(cmake): Use tbb32 pkgconfig package on 32-bit builds (BLAKE3-team/BLAKE3#482)
    (fetchpatch {
      url = "https://github.com/BLAKE3-team/BLAKE3/commit/dab799623310c8f4be6575002d5c681c09a0e209.patch";
      hash = "sha256-npCtM8nOFU8Tcu//IykjMs8aLU12d93+mIfKuxHkuaQ=";
      relative = "c";
    })
    # build(cmake): Relax Clang frontend variant detection (BLAKE3-team/BLAKE3#477)
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/BLAKE3-team/BLAKE3/pull/477.patch";
      hash = "sha256-kidCMGd/i9D9HLLTt7l1DbiU71sFTEyr3Vew4XHUHls=";
      relative = "c";
    })
  ];

  sourceRoot = finalAttrs.src.name + "/c";

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals useTBB [
    onetbb
  ];

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
      fpletz
      silvanshade
    ];
    platforms = lib.platforms.all;
  };
})
