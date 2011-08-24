{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, libsamplerate, flac, lame,
  expat, id3lib, ffmpeg, portaudio
  }:

stdenv.mkDerivation rec {
  version = "1.3.13";
  name = "audacity-${version}";

  NIX_CFLAGS_COMPILE = "-fPIC -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0 -lz";

  src = fetchurl {
    url = "mirror://sourceforge/audacity/audacity-minsrc-${version}-beta.tar.bz2";
    sha256 = "4c2eda638e16e16dfddd202e86ccbe1d170b04c26cfb2c12ffcba0b79e7e1e83";
  };
  buildInputs = [ wxGTK pkgconfig gettext gtk glib zlib intltool perl 
    libogg libvorbis libmad alsaLib libsndfile libsamplerate flac lame
    expat id3lib ffmpeg portaudio];

  configureFlags = [
  ];

  dontDisableStatic = true;

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
