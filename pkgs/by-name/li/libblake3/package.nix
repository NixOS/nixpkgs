{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  onetbb,
  testers,

  useTBB ? lib.meta.availableOn stdenv.hostPlatform onetbb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libblake3";
  version = "1.8.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    tag = finalAttrs.version;
    hash = "sha256-l8pLuZVy9U9NyiwCpC9W9XS052eHwiHAcozuPjxNKHE=";
  };

  sourceRoot = finalAttrs.src.name + "/c";

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals useTBB [
    onetbb
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "BLAKE3_USE_TBB" useTBB)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  __structuredAttrs = true;

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
    pkgConfigModules = [ "libblake3" ];
    cmakeConfigModules = [ "blake3" ];
  };
})
