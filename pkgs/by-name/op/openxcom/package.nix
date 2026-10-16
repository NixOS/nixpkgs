{
  boost,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  libGL,
  openssl,
  pkg-config,
  sdl12-compat,
  SDL_image,
  SDL_mixer,
  SDL_gfx,
  stdenv,
  yaml-cpp,
  zlib,
}:

stdenv.mkDerivation {
  pname = "openxcom";
  version = "1.0-unstable-2026-09-28";

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
    boost
    libGL
    libGLU
    sdl12-compat
    SDL_gfx
    SDL_image
    SDL_mixer
    yaml-cpp
    openssl
    zlib
  ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    mainProgram = "openxcom";
    homepage = "https://openxcom.org";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
