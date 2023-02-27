{ lib, stdenv, fetchFromGitHub, autoreconfHook, alsa-lib, fftw,
  libpulseaudio, ncurses, iniparser }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.8.3";

  buildInputs = [
    alsa-lib
    fftw
    libpulseaudio
    ncurses
    iniparser
  ];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    sha256 = "sha256-6xiWhWynIbUWFIieiYIg24PgwnKuNSIEpkY+P6gyFGw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
  };
}
