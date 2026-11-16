{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sdl_gamecontrollerdb";
  version = "0-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "07af1d50187e94c861c9f9f5d8a55b148f11306b";
    hash = "sha256-zvT8MFRGxC8Q3yMONUBIVhpMSbV/dTtiA5UhVBab3bc=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 gamecontrollerdb.txt -t $out/share
    install -Dm644 LICENSE -t $out/share/licenses/sdl_gamecontrollerdb

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Community sourced database of game controller mappings to be used with SDL2 and SDL3 Game Controller functionality";
    homepage = "https://github.com/mdqinc/SDL_GameControllerDB";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.all;
  };
})
