{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, qtbase, qtcharts, qtmultimedia, qtquickcontrols, qtquickcontrols2, qtgraphicaleffects
, faad2, rtl-sdr, soapysdr-with-plugins, libusb-compat-0_1, fftwSinglePrec, lame, mpg123
} :

mkDerivation rec {
  pname = "welle-io";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "welle.io";
    rev = "v${version}";
    sha256 = "1xl1lanw0xgmgks67dbfb2h52jxnrd1i2zik56v0q8dwsr7f0daw";
  };

  nativeBuildInputs = [ cmake pkg-config ];

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

  meta = with lib; {
    description = "A DAB/DAB+ Software Radio";
    homepage = "https://www.welle.io/";
    maintainers = with maintainers; [ ck3d markuskowa ];
    license = licenses.gpl2Only;
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
