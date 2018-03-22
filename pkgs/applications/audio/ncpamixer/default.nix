{ stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkgconfig }:

stdenv.mkDerivation rec {

  name = "ncpamixer-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = version;
    sha256 = "01kvd0pg5yraymlln5xdzqj1r6adxfvvza84wxn2481kcxfral54";
  };

  buildInputs = [ ncurses libpulseaudio ];
  nativeBuildInputs = [ cmake pkgconfig ];

  configurePhase = ''
    make PREFIX=$out build/Makefile
  '';

  buildPhase = ''
    make build
  '';

  meta = with stdenv.lib; {
    description = "An ncurses mixer for PulseAudio inspired by pavucontrol";
    homepage = https://github.com/fulhax/ncpamixer;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
