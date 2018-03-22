{ stdenv, fetchurl, alsaLib, ffmpeg, libjack2, libX11, libXext
, libXfixes, libGLU_combined, pkgconfig, libpulseaudio, qt4, cmake, ninja
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.9";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "1gnf9wbiq2fcbqcn1a5nfmp8r0nxrrlgh2wly2mfkkwymynhx0pk";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = ''
    for i in scripts/ssr-glinject src/AV/Input/GLInjectInput.cpp; do
      substituteInPlace $i \
        --subst-var out \
        --subst-var-by sh ${stdenv.shell}
    done
  '';

  nativeBuildInputs = [ pkgconfig cmake ninja ];
  buildInputs = [
    alsaLib ffmpeg libjack2 libX11 libXext libXfixes libGLU_combined
    libpulseaudio qt4
  ];

  meta = with stdenv.lib; {
    description = "A screen recorder for Linux";
    homepage = http://www.maartenbaert.be/simplescreenrecorder;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
