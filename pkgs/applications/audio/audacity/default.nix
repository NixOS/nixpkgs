{ stdenv, fetchurl, wxGTK, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, soxr, flac, lame, fetchpatch,
  expat, libid3tag, ffmpeg, soundtouch /*, portaudio - given up fighting their portaudio.patch */
  }:

stdenv.mkDerivation rec {
  version = "2.1.1";
  name = "audacity-${version}";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "15c5ff7ac1c0b19b08f4bdcb0f4988743da2f9ed3fab41d6f07600e67cb9ddb6";
  };
  patches = [(fetchpatch {
    name = "new-ffmpeg.patch";
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk"
      + "/audacity-ffmpeg.patch?h=packages/audacity&id=0c1e35798d4d70692";
    sha256 = "19fr674mw844zmkp1476yigkcnmb6zyn78av64ccdwi3p68i00rf";
  })];

  # fix with gcc-5 from http://lists.freebsd.org/pipermail/freebsd-ports-bugs/2012-December/245884.html
  postPatch = ''
    substituteInPlace lib-src/libnyquist/nyquist/ffts/src/fftlib.c \
      --replace 'inline void' 'static inline void'
  '';

  preConfigure = /* we prefer system-wide libs */ ''
    mv lib-src lib-src-rm
    mkdir lib-src
    mv lib-src-rm/{Makefile*,lib-widget-extra,portaudio-v19,portmixer,portsmf,FileDialog,sbsms,libnyquist} lib-src/
    rm -r lib-src-rm/
  '';

  configureFlags = "--with-libsamplerate";

  buildInputs = [
    pkgconfig gettext wxGTK gtk expat alsaLib
    libsndfile soxr libid3tag
    ffmpeg libmad lame libvorbis flac soundtouch
  ]; #ToDo: detach sbsms

  dontDisableStatic = true;
  doCheck = false; # Test fails

  meta = {
    description = "Sound editor with graphical UI";
    homepage = http://audacityteam.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
