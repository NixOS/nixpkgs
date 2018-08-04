{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1, rtl-sdr }:
stdenv.mkDerivation rec {

  version = "18.05";
  name = "rtl_433-${version}";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = "18.05";
    sha256 = "0vfhnjyrx6w1m8g1hww5vdz4zgdlhcaps9g0397mxlki4sm77wpc";
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
