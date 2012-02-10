{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, libosip, libexosip, speex,
  readline, ffmpeg, alsaLib, SDL, libv4l, libtheora, libXv }:
        
stdenv.mkDerivation rec {
  name = "linphone-3.5.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.5.x/sources/${name}.tar.gz";
    sha256 = "1jrgsyx2mn6y50hjfx79fzqhp42r78cjr63w3bfjdl258zy2f6ix";
  };

  buildInputs = [ intltool gtk libglade libosip libexosip speex readline
    ffmpeg alsaLib SDL libv4l libtheora libXv ];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = "GPLv2+";
  };
}
