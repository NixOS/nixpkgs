{ stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkgconfig }:

stdenv.mkDerivation rec {

  pname = "ncpamixer";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = version;
    sha256 = "19pxfvfhhrbfk1wz5awx60y51jccrgrcvlq7lb622sw2z0wzw4ac";
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
