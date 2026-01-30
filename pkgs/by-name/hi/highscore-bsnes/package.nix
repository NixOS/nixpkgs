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
  version = "0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "bsnes";
    rev = "e5f6eb18035be8a9c57ff0119c44852b89e55248";
    hash = "sha256-J2ZPUhDc5oyh+47LTP9a+R4FpSXcbR3Oe/CH77XC4t0=";
  };

  sourceRoot = "${finalAttrs.src.name}/bsnes";

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
  };

  meta = {
    description = "Port of bsnes to Highscore";
    homepage = "https://github.com/highscore-emu/bsnes";
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    inherit (libhighscore.meta) maintainers platforms;
  };
})
