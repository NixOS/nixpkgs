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
  version = "0-unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "bsnes";
    rev = "d4ced9599ac8ffcd006104783c5e7e7e6a1d5a29";
    hash = "sha256-F9YELVKl/6rBOHaec79kSZ+/6fewbFVBZW8HNGr8ts4=";
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
