{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1, rtl-sdr }:
stdenv.mkDerivation rec {

  version = "18.12";
  name = "rtl_433-${version}";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = "18.12";
    sha256 = "0y73g9ffpsgnmfk8lbihyl9d1fd9v91wsn8k8xhsdmgmn4ra1jk5";
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
