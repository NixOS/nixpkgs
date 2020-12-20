{ stdenv, fetchFromGitHub, cmake, pkg-config
, hamlib, rtaudio, alsaLib, libpulseaudio, libjack2, libusb1, soapysdr
} :

stdenv.mkDerivation rec {
  pname = "soapyaudio";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAudio";
    rev = "soapy-audio-${version}";
    sha256 = "0minlsc1lvmqm20vn5hb4im7pz8qwklfy7sbr2xr73xkrbqdahc0";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ hamlib rtaudio alsaLib libpulseaudio libjack2 libusb1 soapysdr ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
    "-DUSE_HAMLIB=ON"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pothosware/SoapyAudio";
    description = "SoapySDR plugin for amateur radio and audio devices";
    license = licenses.mit;
    maintainers = with maintainers; [ numinit ];
    platforms = platforms.linux;
  };
}
