{ stdenv, fetchurl, alsaLib, ffmpeg, libjack2, libX11, libXext
, libXfixes, mesa, pkgconfig, libpulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.6";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "1d89ncspjd8c4mckf0nb6y3hrxpv4rjpbj868pznhvfmdgr5nvql";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    # #455
    sed '1i#include <random>' -i src/Benchmark.cpp

    for i in scripts/ssr-glinject src/AV/Input/GLInjectInput.cpp; do
      substituteInPlace $i \
        --subst-var out \
        --subst-var-by sh ${stdenv.shell}
    done
  '';

  buildInputs = [
    alsaLib ffmpeg libjack2 libX11 libXext libXfixes mesa pkgconfig
    libpulseaudio qt4
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A screen recorder for Linux";
    homepage = http://www.maartenbaert.be/simplescreenrecorder;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
