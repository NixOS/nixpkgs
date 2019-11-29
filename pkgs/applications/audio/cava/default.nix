{ stdenv, fetchFromGitHub, autoreconfHook, alsaLib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.6.1";

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
    sha256 = "1kvhqgijs29909w3sq9m0bslx2zxxn4b3i07kdz4hb0dqkppxpjy";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postConfigure = ''
    substituteInPlace Makefile.am \
      --replace "-L/usr/local/lib -Wl,-rpath /usr/local/lib" ""
    substituteInPlace configure.ac \
      --replace "/usr/share/consolefonts" "$out/share/consolefonts"
  '';

  meta = with stdenv.lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = https://github.com/karlstav/cava;
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
  };
}
