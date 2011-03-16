{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, libosip, libexosip, speex,
  readline, ffmpeg, alsaLib, SDL, libv4l, libtheora }:
        
stdenv.mkDerivation {
  name = "linphone-3.3.2";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/linphone/3.3.x/sources/linphone-3.3.2.tar.gz;
    sha256 = "0plxqs6v2jz6s7ig8wfzg2ivjvdjja5xhqvrcsv644zl3b4igax7";
  };

  buildInputs = [ intltool pkgconfig gtk libglade libosip libexosip speex readline
    ffmpeg alsaLib SDL libv4l libtheora ];

  meta = {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = "GPLv2+";
  };
}
