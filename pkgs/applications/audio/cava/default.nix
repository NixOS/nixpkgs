{ stdenv, fetchFromGitHub, autoreconfHook, alsaLib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  name = "cava-${version}";
  version = "0.4.1";

  buildInputs = [
    alsaLib
    fftw
    libpulseaudio
    ncurses
  ];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    sha256 = "157hw4cn3qjic7ymn5vy67paxmzssc33h1zswx72ss7j6nc8707f";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postConfigure = ''
    substituteInPlace Makefile \
      --replace "-L/usr/local/lib -Wl,-rpath /usr/local/lib" ""
  '';

  meta = with stdenv.lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = https://github.com/karlstav/cava;
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
  };
}
