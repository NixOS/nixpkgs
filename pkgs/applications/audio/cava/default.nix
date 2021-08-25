{ lib, stdenv, fetchFromGitHub, autoreconfHook, alsa-lib, fftw,
  libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  pname = "cava";
  version = "0.7.4";

  buildInputs = [
    alsa-lib
    fftw
    libpulseaudio
    ncurses
  ];

  src = fetchFromGitHub {
    owner = "karlstav";
    repo = "cava";
    rev = version;
    sha256 = "sha256-BlHGst34aUgQcXcuQG43VnKUTclCxfQmWRa6iCud8dc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postConfigure = ''
    substituteInPlace Makefile.am \
      --replace "-L/usr/local/lib -Wl,-rpath /usr/local/lib" ""
    substituteInPlace configure.ac \
      --replace "/usr/share/consolefonts" "$out/share/consolefonts"
  '';

  meta = with lib; {
    description = "Console-based Audio Visualizer for Alsa";
    homepage = "https://github.com/karlstav/cava";
    license = licenses.mit;
    maintainers = with maintainers; [ offline mirrexagon ];
    platforms = platforms.linux;
  };
}
