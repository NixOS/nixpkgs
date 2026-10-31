{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  python3,
  makeBinaryWrapper,

  SDL2,
  SDL2_mixer,
  the-foundation,
  ncurses,
  glbinding,
  assimp,
  glib,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "doomsday-engine";
  version = "3.0-unstable-2024-01-23";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "Doomsday-Engine";
    rev = "aa09feba6449efe3b426013a71499bf7c310de15";
    hash = "sha256-ZiVXaAsN8/PsdBgxyw85qxPLkl6xePm+nG2A6V269zU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    makeBinaryWrapper
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    the-foundation
    ncurses
    glbinding
    assimp
    glib
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "DE_USE_SYSTEM_ASSIMP" true)
    (lib.cmakeBool "DE_USE_SYSTEM_GLBINDING" true)
  ];

  preConfigure = ''
    # Doomsday builds PK3 files for these games by default - PK3 files are really just ZIP files,
    # whose contents must have a modification date not earlier than 1980.
    find doomsday/{apps/client/data,libs/gamekit/libs/{doom,heretic,hexen,doom64}/{defs,data}} \
      -exec touch -d '1980-01-01T00:00:00Z' {} +
  '';

  # Doomsday Engine does not like Wayland (will SIGSEGV upon launch)
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/doomsday \
      --set "SDL_VIDEODRIVER" "x11"
  '';

  meta = {
    description = "Doom / Heretic / Hexen port with enhanced graphics (unstable 3.0 branch)";
    homepage = "https://dengine.net/";
    license = with lib.licenses; [
      gpl3 # Applications
      lgpl3 # Core libraries
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = with lib.platforms; unix ++ windows;
    mainProgram = "doomsday";
  };
})
