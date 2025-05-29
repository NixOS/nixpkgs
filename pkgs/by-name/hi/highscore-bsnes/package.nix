{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-bsnes";
  version = "0-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "bsnes";
    rev = "ea065538cc4a2ce7e0046ceba07244170571b2f8";
    hash = "sha256-QDTyV/EDT21Ym8QnRRaKABWPqBJ2nhZfG4uscSctevo=";
  };

  sourceRoot = "source/bsnes";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  makeFlags = [
    "target=highscore"
    "binary=library"
    "build=performance"
    "local=false"
    "platform=linux"
  ];

  installFlags = [
    "libdir=${placeholder "out"}/lib"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of bsnes to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
})
