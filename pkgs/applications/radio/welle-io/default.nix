{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2
, faad2, rtl-sdr, soapysdr-with-plugins, libusb, fftwSinglePrec, lame, mpg123 }:
let

  version = "2.0";

in mkDerivation {

  pname = "welle-io";
  inherit version;

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "v${version}";
    sha256 = "0cp8dyswgwidabaj9bvkkc6hl3160096j6myckd5bw00zxnbfiqn";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    faad2
    fftwSinglePrec
    lame
    libusb
    mpg123
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

  meta = with lib; {
    description = "A DAB/DAB+ Software Radio";
    homepage = https://www.welle.io/;
    maintainers = with maintainers; [ ck3d markuskowa ];
    license = licenses.gpl2;
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
