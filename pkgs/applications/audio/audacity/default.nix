{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, libsamplerate, flac, lame,
  expat, id3lib, ffmpeg, portaudio
  }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "audacity-${version}";

  src = fetchurl {
    url = "http://audacity.googlecode.com/files/audacity-minsrc-${version}.tar.bz2";
    sha256 = "0spbib3f86b4qri0g13idyxvysg28hkpsglmjza681zrln62hjfq";
  };
  buildInputs = [ pkgconfig wxGTK libsndfile expat alsaLib libsamplerate
                  libvorbis libmad flac id3lib ffmpeg gettext ];

  dontDisableStatic = true;

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
