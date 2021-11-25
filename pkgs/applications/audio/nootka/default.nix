{ lib, stdenv, fetchurl, cmake
, alsa-lib, fftwSinglePrec, libjack2, libpulseaudio, libvorbis, soundtouch, qtbase
}:

stdenv.mkDerivation rec {
  pname = "nootka";
  version = "1.4.7";

  src = fetchurl {
    url = "mirror://sourceforge/nootka/${pname}-${version}-source.tar.bz2";
    sha256 = "1y9wlwri74v2z9dwbcfjs7xri54yra24vpwq19xi2lfv1nbs518x";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    alsa-lib fftwSinglePrec libjack2 libpulseaudio libvorbis soundtouch qtbase
  ];

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${libjack2}/include/jack;${libpulseaudio.dev}/include/pulse"
    "-DENABLE_JACK=ON"
    "-DENABLE_PULSEAUDIO=ON"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Application for practicing playing musical scores and ear training";
    homepage = "https://nootka.sourceforge.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
