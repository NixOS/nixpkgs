{ lib, stdenv, fetchurl, cmake
, alsa-lib, fftwSinglePrec, libjack2, libpulseaudio, libvorbis, soundtouch
, qtbase, qtdeclarative, qtgraphicaleffects, qtquickcontrols2, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "nootka";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/nootka/${pname}-${version}-source.tar.bz2";
    sha256 = "sha256-ZHdyLZ3+TCpQ77tcNuDlN2124qLDZu9DdH5x7RI1HIs=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [
    alsa-lib
    fftwSinglePrec
    libjack2
    libpulseaudio
    libvorbis
    soundtouch
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols2
    qttools
  ];

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${libjack2}/include/jack;${libpulseaudio.dev}/include/pulse"
    "-DENABLE_JACK=ON"
    "-DENABLE_PULSEAUDIO=ON"
  ];

  meta = with lib; {
    description = "Application for practicing playing musical scores and ear training";
    homepage = "https://nootka.sourceforge.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mmlb orivej ];
    platforms = platforms.linux;
  };
}
