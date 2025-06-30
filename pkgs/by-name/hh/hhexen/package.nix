{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  SDL,
  SDL_mixer,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hhexen";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "sezero";
    repo = "hhexen";
    rev = "hhexen-${finalAttrs.version}";
    hash = "sha256-D1gIdIqb6RN7TA7ezbBhy2Z82TH1quN8kgAMNRHMfhw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    (lib.getDev SDL)
  ];

  buildInputs = [
    libGL
    libGLU
    SDL
    SDL_mixer
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags = [ "--with-audio=sdlmixer" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hhexen-gl -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "hhexen-";
  };

  meta = {
    description = "Linux port of Raven Game's Hexen";
    homepage = "https://hhexen.sourceforge.net/hhexen.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      moody
      djanatyn
    ];
    mainProgram = "hhexen-gl";
    inherit (SDL.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
