{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig
, libusb1, rtl-sdr, soapysdr-with-plugins
}:

stdenv.mkDerivation rec {
  version = "20.11";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = version;
    sha256 = "093bxjxkg7yf78wqj5gpijbfa2p05ny09qqsj84kzi1svnzsa369";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ libusb1 rtl-sdr soapysdr-with-plugins ];

  doCheck = true;

  meta = with lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz";
    homepage = "https://github.com/merbanan/rtl_433";
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = platforms.all;
  };

}
