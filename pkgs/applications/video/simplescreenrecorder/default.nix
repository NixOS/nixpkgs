{ stdenv, fetchurl, alsaLib, ffmpeg, jackaudio, libX11, libXext
, libXfixes, mesa, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "0k1r1ilpk05qmwpnld95zxxk57qvyaq2r9f4i3la7y0xh9bz1gls";
  };

  buildInputs = [
    alsaLib ffmpeg jackaudio libX11 libXext libXfixes mesa pkgconfig
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
