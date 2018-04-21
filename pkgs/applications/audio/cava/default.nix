{ stdenv, fetchFromGitHub, autoreconfHook, alsaLib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  name = "cava-${version}";
  version = "0.6.0";

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
    sha256 = "01maaq5pfd4a7zilgarwr1nl7jbqyrvir6w7ikchggsckrlk23wr";
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
