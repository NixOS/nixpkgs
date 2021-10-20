{ lib, stdenv, fetchurl, cmake, libusb-compat-0_1 }:

stdenv.mkDerivation rec {
  pname = "garmindev";
  version = "0.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/qlandkartegt/${pname}-${version}.tar.gz";
    sha256 = "1mc7rxdn9790pgbvz02xzipxp2dp9h4hfq87xgawa18sp9jqzhw6";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libusb-compat-0_1 ];

  meta = with lib; {
    homepage = "http://www.qlandkarte.org/";
    description = "Garmin Device Drivers for QlandkarteGT";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = [ "x86_64-linux" ];
  };
}
