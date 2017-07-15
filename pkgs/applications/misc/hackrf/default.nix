{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "hackrf-${version}";
  version = "2015.07.2";

  src = fetchFromGitHub {
    owner = "mossmann";
    repo = "hackrf";
    rev = "refs/tags/v${version}";
    sha256 = "1q54j7k9bwy6q2hlgjxdd2fn6impf7fx36p4jj94g3jjf71qcqi2";
  };

  buildInputs = [
    cmake pkgconfig libusb
  ];

  preConfigure = ''
    cd host
  '';

  meta = with stdenv.lib; {
    description = "An open source SDR platform";
    homepage = http://greatscottgadgets.com/hackrf/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ sjmackenzie the-kenny ];
  };
}
