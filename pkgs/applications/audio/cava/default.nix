{ stdenv, fetchFromGitHub, autoreconfHook, alsaLib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.7.1";

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
    sha256 = "0p2g3xxl2n425bghs1qnff30jaj9cba94j2gbhgxmwaxhz26vbk7";
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
