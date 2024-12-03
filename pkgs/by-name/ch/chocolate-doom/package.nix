{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  SDL2,
  SDL2_mixer,
  SDL2_net,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chocolate-doom";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = "chocolate-doom";
    rev = "refs/tags/chocolate-doom-${finalAttrs.version}";
    hash = "sha256-yDPfqCuzRbDhOQisIDAGo2bmmMjT+0lds5xc9C2pqoU=";
  };

  postPatch = ''
    patchShebangs --build man/{simplecpp,docgen}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # for documentation
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_net
  ];

  outputs = [
    "out"
    "man"
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "https://www.chocolate-doom.org";
    description = "Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    mainProgram = "chocolate-doom";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # darwin times out
    maintainers = with lib.maintainers; [ Gliczy ];
  };
})
