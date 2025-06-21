{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  SDL2,
  SDL2_net,
  alsa-lib,
  fluidsynth,
  libebur128,
  libsndfile,
  libxmp,
  openal,
  yyjson,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nugget-doom";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "MrAlaux";
    repo = "Nugget-Doom";
    tag = "nugget-doom-${finalAttrs.version}";
    hash = "sha256-T85UwCl75/RPOscfcRVlF3HhjlDVM2+W1L002UGNLZU=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_net
    alsa-lib
    fluidsynth
    libebur128
    libsndfile
    libxmp
    openal
    yyjson
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Doom source port forked from Woof! with additional features";
    homepage = "https://github.com/MrAlaux/Nugget-Doom";
    changelog = "https://github.com/fabiangreffrath/woof/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bandithedoge ];
    mainProgram = "nugget-doom";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
  };
})
