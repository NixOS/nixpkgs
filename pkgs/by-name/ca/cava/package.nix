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

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-qpQ1WFWqq4FzeN0Yy8ke3mOYtGXmK998yZAy9OTBGq4=";
  };

  buildInputs =
    [
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
    echo ${version} > version
  '';

  meta = with lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [
      offline
      mirrexagon
    ];
    platforms = platforms.unix;
    mainProgram = "cava";
  };
}
