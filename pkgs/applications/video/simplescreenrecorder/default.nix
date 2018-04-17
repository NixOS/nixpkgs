{ stdenv, fetchurl, alsaLib, ffmpeg, libjack2, libX11, libXext
, libXfixes, libGLU_combined, pkgconfig, libpulseaudio, qt4, cmake, ninja
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.10";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "02rl9yyx3hlz9fqvgzv7ipmvx2qahj7ws5wx2m7zs3lssq3qag3g";
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
