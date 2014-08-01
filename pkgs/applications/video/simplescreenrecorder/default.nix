{ stdenv, fetchurl, alsaLib, ffmpeg, jack2, libX11, libXext
, libXfixes, mesa, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "0caal8jq47d56ld57cdf2lr1ji350v09j5chgvgxv2pbqmqga4p5";
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
