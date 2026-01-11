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
  version = "0-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "bsnes";
    rev = "7e26b2970c95404ef9a95bed6e509c8923f2815d";
    hash = "sha256-mOJPhhHqVrYIHYUZ7z1fA8AD6yjWcnUxecMorsaPvFg=";
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
