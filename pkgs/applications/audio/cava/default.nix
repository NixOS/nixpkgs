{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  alsa-lib,
  fftw,
  iniparser,
  libpulseaudio,
  pipewire,
  ncurses,
  pkgconf,
  SDL2,
  libGL,
  withSDL2 ? false,
  withPipewire ? true,
}:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-y6RslsU/zmr0Ai/rnr73N3OtjuBcWa3JCwh9P5GkNss=";
  };

  buildInputs =
    [
      alsa-lib
      fftw
      libpulseaudio
      ncurses
      iniparser
    ]
    ++ lib.optionals withSDL2 [
      SDL2
      libGL
    ]
    ++ lib.optionals withPipewire [
      pipewire
    ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkgconf
  ];

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
    platforms = platforms.linux;
    mainProgram = "cava";
  };
}
