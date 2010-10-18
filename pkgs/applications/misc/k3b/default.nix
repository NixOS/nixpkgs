{ stdenv, fetchurl, cmake, qt4, perl, shared_mime_info, libvorbis, taglib
, ffmpeg, flac, libsamplerate, libdvdread, lame, libsndfile, libmad, gettext
, kdelibs, kdemultimedia, cdrdao, cdrtools, dvdplusrwtools
, automoc4, phonon, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "k3b-2.0.1";
  src = fetchurl {
    url = "mirror://sourceforge/k3b/${name}.tar.bz2";
    sha256 = "1dyd3i2hqd5xs9rz4f8k74zca91j9sp72lhl0zws2cvqc474ccc6";
  };

  buildInputs = [ cmake qt4 perl shared_mime_info libvorbis taglib
                  ffmpeg flac libsamplerate libdvdread lame libsndfile
                  libmad gettext stdenv.gcc.libc cdrdao cdrtools
                  kdelibs kdemultimedia automoc4 phonon dvdplusrwtools
                  makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/k3b --suffix PATH : "${cdrdao}/bin:${dvdplusrwtools}/bin:${cdrtools}/bin"
  '';

  meta = with stdenv.lib; {
    description = "CD/DVD Burning Application for KDE";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sander maintainers.urkud ];
  };
}
