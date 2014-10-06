{ stdenv, fetchurl, alsaLib, ffmpeg, jack2, libX11, libXext
, libXfixes, mesa, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "00ra4isl4yf5l6q1cp97ss46jck1iayv1d23iz4885yzxknvhhjn";
  };

  buildInputs = [
    alsaLib ffmpeg jack2 libX11 libXext libXfixes mesa pkgconfig
    pulseaudio qt4
  ];

  meta = with stdenv.lib; {
    description = "A screen recorder for Linux";
    homepage = http://www.maartenbaert.be/simplescreenrecorder;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
