{
  gamekitPath,
  ...
}@drvArgs:
{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  python3,

  SDL2,
  SDL2_mixer,
  the-foundation,
  ncurses,
}:
stdenv.mkDerivation (drvArgs // {
  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ] ++ (drvArgs.nativeBuildInputs or [ ]);

  buildInputs = [
    SDL2
    SDL2_mixer
    the-foundation
    ncurses
  ] ++ (drvArgs.buildInputs or [ ]);

  preConfigure = ''
    # Doomsday builds PK3 files for these games by default - PK3 files are really just ZIP files,
    # whose contents must have a modification date not earlier than 1980.
    find doomsday/{apps/client/data,${gamekitPath}/{doom,heretic,hexen,doom64}/{defs,data}} \
      -exec touch -d '1980-01-01T00:00:00Z' {} +
  '' + drvArgs.preConfigure or "";

  meta = {
    description = "Doom / Heretic / Hexen port with enhanced graphics";
    homepage = "https://dengine.net/";
    license = with lib.licenses; [
      gpl3 # Applications
      lgpl3 # Core libraries
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "doomsday";
  } // (drvArgs.meta or { });
})
