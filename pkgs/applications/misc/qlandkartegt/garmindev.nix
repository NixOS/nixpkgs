{ stdenv, fetchurl, cmake, libusb }:

stdenv.mkDerivation rec {
  name = "garmindev-${version}";
  version = "0.3.4";

  src = fetchurl {
    url = "https://bitbucket.org/maproom/qlandkarte-gt/downloads/${name}.tar.gz";
    sha256 = "1mc7rxdn9790pgbvz02xzipxp2dp9h4hfq87xgawa18sp9jqzhw6";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libusb ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.qlandkarte.org/;
    description = "Garmin Device Drivers for QlandkarteGT";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = [ "x86_64-linux" ];
  };
}
