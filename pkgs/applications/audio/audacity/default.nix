{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, libsamplerate, flac, lame,
  expat, id3lib, ffmpeg
  }:

stdenv.mkDerivation rec {
  version = "1.3.12";
  name = "audacity-${version}";

  NIX_CFLAGS_COMPILE = "-fPIC -lgtk-x11-2.0 -lglib-2.0 -lgobject-2.0 -lz";

  src = fetchurl {
    url = "mirror://sourceforge/audacity/audacity-minsrc-${version}-beta.tar.bz2";
    sha256 = "f0f55839ca3013d2e43e5114c73d195bc34503685aeab683eafca4d1bbf3b768";
  };
  buildInputs = [ wxGTK pkgconfig gettext gtk glib zlib intltool perl 
    libogg libvorbis libmad alsaLib libsndfile libsamplerate flac lame
    expat id3lib ffmpeg];

  configureFlags = [
    "--with-portmixer=no"
  ];

  dontDisableStatic = true;

  preBuild = ''
    (cd lib-src ; make portaudio-v19/lib/libportaudio.a ; ln -sf portaudio-v19/lib/.libs/libportaudio.a portaudio-v19/lib/libportaudio.a)
  '';

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacity.sourceforge.net;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
