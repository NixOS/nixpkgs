{ stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkgconfig }:

stdenv.mkDerivation rec {

  name = "ncpamixer-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = version;
    sha256 = "02v8vsx26w3wrzkg61457diaxv1hyzsh103p53j80la9vglamdsh";
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
