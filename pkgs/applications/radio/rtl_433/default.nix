{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libusb1, rtl-sdr, soapysdr-with-plugins
}:

stdenv.mkDerivation {

  version = "19.08";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = "19.08";
    sha256 = "0cm82gm5c86qfl4dw37h8wyk77947k6fv2n1pn3xvk3wz2ygsdi6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libusb1 rtl-sdr soapysdr-with-plugins ];

  meta = with stdenv.lib; {
    description = "Decode traffic from devices that broadcast on 433.9 MHz";
    homepage = https://github.com/merbanan/rtl_433;
    license = licenses.gpl2;
    maintainers = with maintainers; [ earldouglas ];
    platforms = platforms.all;
  };

}
