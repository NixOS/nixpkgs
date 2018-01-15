{ stdenv, buildEnv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2
, faad2, rtl-sdr, libusb, fftwSinglePrec }:
let

  version = "1.0-rc1";

in stdenv.mkDerivation {

  name = "welle-io-${version}";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "V${version}";
    sha256 = "1xi59rmk3rdqqxxxrm2pbllrlsql46vxs95l1pkfx7bp8f7n7rsv";
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
  ];

  cmakeFlags = [
    "-DRTLSDR=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A DAB/DAB+ Software Radio";
    homepage = http://www.welle.io/;
    maintainers = with maintainers; [ ck3d ];
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
  };

}
