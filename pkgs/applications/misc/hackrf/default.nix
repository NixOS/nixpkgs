{ stdenv, fetchgit, cmake, pkgconfig, libusb }:

stdenv.mkDerivation rec {
  name = "hackrf-${version}";
  version = "2015.07.2";

  src = fetchgit {
    url = "git://github.com/mossmann/hackrf";
    rev = "refs/tags/v${version}";
    sha256 = "1mn11yz6hbkmvrbxj5vnp78m5dsny96821a9ffpvbdcwx3s2p23m";
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
