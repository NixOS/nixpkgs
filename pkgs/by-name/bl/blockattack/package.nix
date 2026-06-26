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
  libx11,
  ninja,
  physfs,
  pkg-config,
  stdenv,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blockattack";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "blockattack";
    repo = "blockattack-game";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sp/D0MSLWV1iV89UULlz8IrP5nmiMv6PsoGf1WM5kGw=";
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
    libx11
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
    description = "Open source clone of Panel de Pon (aka Tetris Attack)";
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/blockattack/blockattack-game/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "blockattack";
    maintainers = [ ];
    inherit (SDL2.meta) platforms;
  };
})
