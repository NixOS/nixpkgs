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
  version = "0-unstable-2025-12-23";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "bsnes";
    rev = "df88234e314f97a2ca124df1982e4bd39f6fcea0";
    hash = "sha256-QI9mRvcsPkVBhUZlhchgGVPROj7HAqgtHHnbHVzIIBI=";
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
