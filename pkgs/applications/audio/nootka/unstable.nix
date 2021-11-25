{ lib
, stdenv
, fetchurl
, cmake
, alsa-lib
, fftwSinglePrec
, libjack2
, libpulseaudio
, libvorbis
, soundtouch
, qtbase
, qtdeclarative
, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  pname = "nootka";
  version = "1.7.0-beta1";

  src = fetchurl {
    url = "mirror://sourceforge/nootka/nootka-${version}-source.tar.bz2";
    sha256 = "13b50vnpr1zx2mrgkc8fmhsyfa19rqq1rksvn31145dy6fk1f3gc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    alsa-lib
    fftwSinglePrec
    libjack2
    libpulseaudio
    libvorbis
    soundtouch
    qtbase
    qtdeclarative
    qtquickcontrols2
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${libjack2}/include/jack;${libpulseaudio.dev}/include/pulse"
    "-DENABLE_JACK=ON"
    "-DENABLE_PULSEAUDIO=ON"
  ];

  meta = with lib; {
    description = "Application for practicing playing musical scores and ear training";
    homepage = "https://nootka.sourceforge.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
