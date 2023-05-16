<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, alsa-lib
, fftw
, iniparser
, libpulseaudio
, pipewire
, ncurses
, pkgconf
, SDL2
, libGL
, withSDL2 ? false
, withPipewire ? true
}:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    hash = "sha256-W/2B9iTcO2F2vHQzcbg/6pYBwe+rRNfADdOiw4NY9Jk=";
  };
=======
{ lib, stdenv, fetchFromGitHub, autoreconfHook, alsa-lib, fftw,
  libpulseaudio, ncurses, iniparser }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    alsa-lib
    fftw
    libpulseaudio
    ncurses
    iniparser
<<<<<<< HEAD
  ] ++ lib.optionals withSDL2 [
    SDL2
    libGL
  ] ++ lib.optionals withPipewire [
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
=======
  ];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    sha256 = "sha256-6xiWhWynIbUWFIieiYIg24PgwnKuNSIEpkY+P6gyFGw=";
  };

  nativeBuildInputs = [ autoreconfHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "cava";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
