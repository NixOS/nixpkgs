{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGL,
  libGLU,
  nix-update-script,
  pkg-config,
  SDL_gfx,
  SDL_image,
  SDL_mixer,
  sdl12-compat,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxcom";
  version = "1.0-unstable-2026-09-28";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "4a4bae5fa2e5a09282928e84943fc84b093e34ff";
    hash = "sha256-hgW0n1BzzQe0guXJWF9KlDcpWz1JpFFJ6IGPP1nZgTA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    libGLU
    SDL_gfx
    SDL_image
    SDL_mixer
    sdl12-compat
    yaml-cpp
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = "https://openxcom.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "openxcom";
    platforms = lib.platforms.linux;
  };
})
