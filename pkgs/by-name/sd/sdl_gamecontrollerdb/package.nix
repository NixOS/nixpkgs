{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sdl_gamecontrollerdb";
<<<<<<< HEAD
  version = "0-unstable-2025-12-26";
=======
  version = "0-unstable-2025-11-17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
<<<<<<< HEAD
    rev = "547fb8019f8cf7c443244b918c5be05c9e5a53f3";
    hash = "sha256-mPVnxDuivh+jBf25jPo3wA/CHAgGkzAb2ybbRLmdE/o=";
=======
    rev = "e1efb4bad8730b2c0c6316617cbd06b9def1192e";
    hash = "sha256-NeNWDVFEK54v5GoBybWeiNeJoe7u3e0Ci0yTB5n/57U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
