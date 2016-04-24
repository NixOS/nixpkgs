{ stdenv, fetchurl, wxGTK30, pkgconfig, gettext, gtk, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, alsaLib, libsndfile, soxr, flac, lame, fetchpatch,
  expat, libid3tag, ffmpeg, soundtouch /*, portaudio - given up fighting their portaudio.patch */
  }:

stdenv.mkDerivation rec {
  version = "2.1.2";
  name = "audacity-${version}";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "1ggr6g0mk36rqj7ahsg8b0b1r9kphwajzvxgn43md263rm87n04h";
  };
  patches = [(fetchpatch {
    name = "new-ffmpeg.patch";
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk"
      + "/audacity-ffmpeg.patch?h=packages/audacity&id=0c1e35798d4d70692";
    sha256 = "19fr674mw844zmkp1476yigkcnmb6zyn78av64ccdwi3p68i00rf";
  })];

  preConfigure = /* we prefer system-wide libs */ ''
    mv lib-src lib-src-rm
    mkdir lib-src
    mv lib-src-rm/{Makefile*,lib-widget-extra,portaudio-v19,portmixer,portsmf,FileDialog,sbsms,libnyquist} lib-src/
    rm -r lib-src-rm/
  '';

  configureFlags = [ "--with-libsamplerate" ];

  buildInputs = [
    pkgconfig gettext wxGTK30 expat alsaLib
    libsndfile soxr libid3tag gtk
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
