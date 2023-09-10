{ lib, stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ncpamixer";
  version = "1.3.3.5";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = version;
    sha256 = "sha256-iwwfuMZn8HwnTIEBgTuvnJNlRlPt4G+j/piXO8S7mPc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ ncurses libpulseaudio ];

  configurePhase = ''
    make PREFIX=$out USE_WIDE=1 RELEASE=1 build/Makefile
  '';

  meta = with lib; {
    description = "An ncurses mixer for PulseAudio inspired by pavucontrol";
    homepage = "https://github.com/fulhax/ncpamixer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = teams.c3d2.members;
  };
}
