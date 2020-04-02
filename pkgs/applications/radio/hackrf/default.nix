{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1, fftwSinglePrec }:

stdenv.mkDerivation rec {
  pname = "hackrf";
  version = "2018.01.1";

  src = fetchFromGitHub {
    owner = "mossmann";
    repo = "hackrf";
    rev = "v${version}";
    sha256 = "0idh983xh6gndk9kdgx5nzz76x3mxb42b02c5xvdqahadsfx3b9w";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    libusb1
    fftwSinglePrec
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
