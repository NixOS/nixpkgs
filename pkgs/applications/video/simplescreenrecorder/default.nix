{ stdenv, fetchurl, alsaLib, ffmpeg, jack2, libX11, libXext
, libXfixes, mesa, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "09mcmvqbzq2blv404pklv6fc8ci3a9090p42rdsgmlr775bdyxfb";
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
