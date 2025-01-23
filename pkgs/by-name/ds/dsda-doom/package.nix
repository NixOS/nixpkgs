{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_mixer,
  SDL2_image,
  fluidsynth,
  portmidi,
  dumb,
  libvorbis,
  libmad,
  libGLU,
  libzip,
  alsa-lib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "dsda-doom";
  version = "0.28.3";

  src = fetchFromGitHub {
    owner = "kraflab";
    repo = "dsda-doom";
    rev = "v${version}";
    hash = "sha256-66o/k5DvyKxwa0sZPCfSycVRxEhrRhUJXJVz2p817OE=";
  };

  sourceRoot = "${src.name}/prboom2";

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    alsa-lib
    dumb
    fluidsynth
    libGLU
    libmad
    libvorbis
    libzip
    portmidi
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kraflab/dsda-doom";
    changelog = "https://github.com/kraflab/dsda-doom/releases/tag/v${version}";
    description = "Advanced Doom source port with a focus on speedrunning, successor of PrBoom+";
    mainProgram = "dsda-doom";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
}
