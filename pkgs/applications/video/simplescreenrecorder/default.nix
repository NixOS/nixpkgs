{ stdenv, fetchurl, alsaLib, ffmpeg, jack2, libX11, libXext
, libXfixes, mesa, pkgconfig, pulseaudio, qt4
}:

stdenv.mkDerivation rec {
  name = "simplescreenrecorder-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/MaartenBaert/ssr/archive/${version}.tar.gz";
    sha256 = "0g226n09h0m3n36ahfmvm70szwvn8345zywb1f05l1nab6mx6wj3";
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
