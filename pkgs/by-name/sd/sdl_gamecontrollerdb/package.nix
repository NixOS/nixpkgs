{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sdl_gamecontrollerdb";
  version = "0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "07a5c6b80262a208200573186eb5d5ac2518e89d";
    hash = "sha256-Lz55pKQ5vT3kAAziOKzT5q8GCVHO/GOZ8fOC8BHoMJA=";
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
