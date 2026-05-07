{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  alsa-lib,
  fftw,
  iniparser,
  libGL,
  libpulseaudio,
  libtool,
  ncurses,
  pipewire,
  pkgconf,
  portaudio,
  SDL2,
  versionCheckHook,
  withSDL2 ? false,
  withPipewire ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cava";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    tag = finalAttrs.version;
    hash = "sha256-eOGUDGGlja5Cq8XTJFRqyP6qyaoxOJm09vZrlk4KS9k=";
  };

  buildInputs = [
    fftw
    iniparser
    libpulseaudio
    libtool
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    portaudio
  ]
  ++ lib.optionals withSDL2 [
    libGL
    SDL2
  ]
  ++ lib.optionals withPipewire [
    pipewire
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkgconf
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-v";

  preAutoreconf = ''
    echo ${finalAttrs.version} > version
  '';

  meta = {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mirrexagon
    ];
    platforms = lib.platforms.unix;
    mainProgram = "cava";
  };
})
