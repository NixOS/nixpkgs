{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, libosip, libexosip, speex,
  readline, ffmpeg, alsaLib, SDL, libv4l, libtheora, libXv }:
        
stdenv.mkDerivation rec {
  name = "linphone-3.4.3";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.4.x/sources/${name}.tar.gz";
    sha256 = "14k655z0kfmnm42nxhsl25rjim9swrr4kpnplkx3pd9b3yha1rwj";
  };

  buildInputs = [ intltool pkgconfig gtk libglade libosip libexosip speex readline
    ffmpeg alsaLib SDL libv4l libtheora libXv ];

  meta = {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = "GPLv2+";
  };
}
