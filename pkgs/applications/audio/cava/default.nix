{ stdenv, fetchFromGitHub, autoreconfHook, alsaLib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.7.3";

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
    sha256 = "04j5hb29hivcbk542sfsx9m57dbnj2s6qpvy9fs488zvgjbgxrai";
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
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
  };
}
