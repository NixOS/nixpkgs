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
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "bsnes";
    rev = "db1f255622b3410485a54c7c0097c747e7144091";
    hash = "sha256-SZugEb/vzFlzHjgHE/5ha03ULB95886N0b15iIlTsqA=";
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
