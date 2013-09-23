{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, soxr, flac, lame,
  expat, libid3tag, ffmpeg /*, portaudio - given up fighting their portaudio.patch */
  }:

stdenv.mkDerivation rec {
  version = "2.0.4";
  name = "audacity-${version}";

  src = fetchurl {
    url = "http://audacity.googlecode.com/files/audacity-minsrc-${version}.tar.xz";
    sha256 = "0pl92filykzs4g2pn7i02kdqgja326wjgafzw2vcgwn3dwrs4avp";
  };

  preConfigure = /* we prefer system-wide libs */ ''
    mv lib-src lib-src-rm
    mkdir lib-src
    mv lib-src-rm/{Makefile*,lib-widget-extra,portaudio-v19,portmixer,portsmf,FileDialog,sbsms} lib-src/
    rm -r lib-src-rm/
  '';

  buildInputs = [
    pkgconfig gettext wxGTK gtk expat alsaLib
    libsndfile soxr libid3tag
    ffmpeg libmad lame libvorbis flac
  ]; #ToDo: soundtouch, detach sbsms

  dontDisableStatic = true;
  doCheck = true;

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
