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
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-oKEUddzg7Gt3uu6x9D65JX0PvuC59r7Psb9VZz3+nCc=";
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
