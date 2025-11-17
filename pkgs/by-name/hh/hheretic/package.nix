{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL,
  SDL_mixer,
  libGL,
  libGLU,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hheretic";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sezero";
    repo = "hheretic";
    rev = "hheretic-${finalAttrs.version}";
    hash = "sha256-49eQeh0suU+7QLB25cvrqirZRaBgZp438H6NW0pWsPI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    (lib.getDev SDL)
  ];

  buildInputs = [
    SDL
    SDL_mixer
    libGL
    libGLU
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags = [ "--with-audio=sdlmixer" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hheretic-gl -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "hheretic-";
  };

  meta = {
    description = "Linux port of Raven Game's Heretic";
    homepage = "https://hhexen.sourceforge.net/hhexen.html";
    license = lib.licenses.gpl2Plus;
    mainProgram = "hheretic-gl";
    maintainers = with lib.maintainers; [ moody ];
    inherit (SDL.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
