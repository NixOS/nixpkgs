{ lib, stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ncpamixer";
  version = "1.3.3.1";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = version;
    sha256 = "1v3bz0vpgh18257hdnz3yvbnl51779g1h5b265zgc21ks7m1jw5z";
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
    maintainers = with maintainers; [ StijnDW SuperSandro2000 ];
  };
}
