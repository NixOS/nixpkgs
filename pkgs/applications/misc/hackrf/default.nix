{ stdenv, fetchgit, cmake, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "hackrf-${version}";
  version = "2015.07.2";

  src = fetchgit {
    url = "git://github.com/mossmann/hackrf";
    rev = "refs/tags/v${version}";
    sha256 = "0wa4m0kdq8q2ib724w8ry8shmmm1liaaawhjygrjx6zxz9jxr3vm";
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
