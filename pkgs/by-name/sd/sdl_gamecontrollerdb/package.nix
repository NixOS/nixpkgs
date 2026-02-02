{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sdl_gamecontrollerdb";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "fc25a0299e8dcb7a8fc072864297c71f71d6f3d7";
    hash = "sha256-lR/SBVLjb9KvXogd46hSEuKY5Z0NmhDdnLwhf1IWhQ0=";
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
