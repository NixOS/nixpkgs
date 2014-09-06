{ stdenv, fetchurl, cmake, qt4, perl, shared_mime_info, libvorbis, taglib
, flac, libsamplerate, libdvdread, lame, libsndfile, libmad, gettext
, transcode, cdrdao, dvdplusrwtools, vcdimager
, kdelibs, kdemultimedia, automoc4, phonon, libkcddb ? null
}:

stdenv.mkDerivation rec {
  name = "k3b-2.0.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/k3b/${name}.tar.bz2";
    sha256 = "1kdpylz3w9bg02jg4mjhqz8bq1yb4xi4fqfl9139qcyjq4lny5xg";
  };

  buildInputs =
    [ cmake qt4 perl shared_mime_info libvorbis taglib
      flac libsamplerate libdvdread lame libsndfile
      libmad gettext stdenv.gcc.libc
      kdelibs kdemultimedia automoc4 phonon
      libkcddb
    ];

  enableParallelBuilding = true;

  # at runtime, k3b needs the executables cdrdao, cdrecord, dvd+rw-format,
  # eMovix, growisofs, mkisofs, normalize, readcd, transcode, vcdxbuild,
  # vcdxminfo, and vcdxrip
  propagatedUserEnvPkgs = [ transcode dvdplusrwtools cdrdao vcdimager ];
                  
  meta = with stdenv.lib; {
    description = "CD/DVD Burning Application for KDE";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sander maintainers.urkud maintainers.phreedom ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
