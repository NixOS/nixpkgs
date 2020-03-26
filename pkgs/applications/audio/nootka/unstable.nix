{ stdenv, fetchurl, cmake
, alsaLib, fftwSinglePrec, libjack2, libpulseaudio, libvorbis, soundtouch
, qtbase, qtdeclarative, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  name = "nootka-1.7.0-beta1";

  src = fetchurl {
    url = "mirror://sourceforge/nootka/${name}-source.tar.bz2";
    sha256 = "13b50vnpr1zx2mrgkc8fmhsyfa19rqq1rksvn31145dy6fk1f3gc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    alsaLib fftwSinglePrec libjack2 libpulseaudio libvorbis soundtouch
    qtbase qtdeclarative qtquickcontrols2
  ];

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${libjack2}/include/jack;${libpulseaudio.dev}/include/pulse"
    "-DENABLE_JACK=ON"
    "-DENABLE_PULSEAUDIO=ON"
  ];

  meta = with stdenv.lib; {
    description = "Application for practicing playing musical scores and ear training";
    homepage = https://nootka.sourceforge.io/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
