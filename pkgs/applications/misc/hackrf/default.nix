{ stdenv, fetchgit, cmake, pkgconfig, libusb, fftwSinglePrec }:

stdenv.mkDerivation rec {
  name = "hackrf-${version}";
  version = "2017.02.1";

  src = fetchgit {
    url = "git://github.com/mossmann/hackrf";
    rev = "refs/tags/v${version}";
    sha256 = "16hd61icvzaciv7s9jpgm9c8q6m4mwvj97gxrb20sc65p5gjb7hv";
  };

  buildInputs = [
    cmake pkgconfig libusb fftwSinglePrec
  ];

  cmakeFlags = [ "-DUDEV_RULES_GROUP=plugdev" "-DUDEV_RULES_PATH=lib/udev/rules.d" ];

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
