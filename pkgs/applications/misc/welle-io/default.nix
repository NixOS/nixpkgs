{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2
, faad2, rtl-sdr, soapysdr-with-plugins, libusb, fftwSinglePrec }:
let

  version = "1.0-rc2";

in stdenv.mkDerivation {

  name = "welle-io-${version}";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "V${version}";
    sha256 = "01x4ldq6lvmdrmxi857594nj9xpn2h7848vvf3f54sh1zrawn4k4";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    faad2
    fftwSinglePrec
    libusb
    qtbase
    qtcharts
    qtmultimedia
    qtquickcontrols
    qtquickcontrols2
    rtl-sdr
    soapysdr-with-plugins
  ];

  cmakeFlags = [
    "-DRTLSDR=true" "-DSOAPYSDR=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A DAB/DAB+ Software Radio";
    homepage = https://www.welle.io/;
    maintainers = with maintainers; [ ck3d ];
    license = licenses.gpl2;
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
