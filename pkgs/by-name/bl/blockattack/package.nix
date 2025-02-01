{
  lib,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  boost,
  cmake,
  fetchFromGitHub,
  gettext,
  gitUpdater,
  ninja,
  physfs,
  pkg-config,
  stdenv,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blockattack";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "blockattack";
    repo = "blockattack-game";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6mPj6A7mYm4CXkSSemNPn1CPkd7+01yr8KvCBM3a5po=";
  };

  nativeBuildInputs = [
    SDL2
    cmake
    ninja
    pkg-config
    gettext
    zip
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    SDL2_ttf
    boost
    physfs
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  preConfigure = ''
    patchShebangs packdata.sh source/misc/translation/*.sh
    chmod +x ./packdata.sh
    ./packdata.sh
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://blockattack.net/";
    description = "An open source clone of Panel de Pon (aka Tetris Attack)";
    broken = stdenv.isDarwin;
    changelog = "https://github.com/blockattack/blockattack-game/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "blockattack";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (SDL2.meta) platforms;
  };
})
