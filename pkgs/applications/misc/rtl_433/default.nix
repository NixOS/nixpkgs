{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1, rtl-sdr }:
stdenv.mkDerivation rec {

  version = "2018-02-23";
  name = "rtl_433-${version}";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = "51d275c";
    sha256 = "1j443wmws5xgc18s47bvw3pqljk747izypz52rmlrvs16v96cg2g";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libusb1 rtl-sdr ];

  meta = with stdenv.lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz";
    homepage = https://github.com/merbanan/rtl_433;
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = platforms.all;
  };

}
