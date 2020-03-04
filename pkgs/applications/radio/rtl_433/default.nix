{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libusb1, rtl-sdr, soapysdr-with-plugins
}:

stdenv.mkDerivation {

  version = "20.02";
  pname = "rtl_433";

  src = fetchFromGitHub {
    owner = "merbanan";
    repo = "rtl_433";
    rev = "20.02";
    sha256 = "11991xky9gawkragdyg27qsf7kw5bhlg7ygvf3fn7ng00x4xbh1z";
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
