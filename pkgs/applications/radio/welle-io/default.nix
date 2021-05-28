{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2, qtgraphicaleffects
, faad2, rtl-sdr, soapysdr-with-plugins, libusb-compat-0_1, fftwSinglePrec, lame, mpg123 }:
let

  version = "2.2";

in mkDerivation {

  pname = "welle-io";
  inherit version;

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "v${version}";
    sha256 = "04fpm6sc431dl9i5h53xpd6k85j22sv8aawl7b6wv2fzpfsd9fwa";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    faad2
    fftwSinglePrec
    lame
    libusb-compat-0_1
    mpg123
    qtbase
    qtcharts
    qtmultimedia
    qtquickcontrols
    qtquickcontrols2
    qtgraphicaleffects
    rtl-sdr
    soapysdr-with-plugins
  ];

  cmakeFlags = [
    "-DRTLSDR=true" "-DSOAPYSDR=true"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A DAB/DAB+ Software Radio";
    homepage = "https://www.welle.io/";
    maintainers = with maintainers; [ ck3d markuskowa ];
    license = licenses.gpl2;
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
