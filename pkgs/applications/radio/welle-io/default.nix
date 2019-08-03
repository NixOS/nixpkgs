{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2
, faad2, rtl-sdr, soapysdr-with-plugins, libusb, fftwSinglePrec }:
let

  version = "1.0";

in stdenv.mkDerivation {

  name = "welle-io-${version}";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "V${version}";
    sha256 = "1fsr0c2w16z45mcr85sqmllw1xf2gn6hp6f6fmgx2zfprq8gdmcr";
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
    maintainers = with maintainers; [ ck3d markuskowa ];
    license = licenses.gpl2;
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
