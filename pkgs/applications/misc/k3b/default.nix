{ stdenv, fetchurl, cmake, qt4, perl, shared_mime_info, libvorbis, taglib
, flac, libsamplerate, libdvdread, lame, libsndfile, libmad, gettext
, transcode, cdrdao, dvdplusrwtools, vcdimager
, kdelibs, kdemultimedia, automoc4, phonon, libkcddb ? null
}:

stdenv.mkDerivation rec {
  name = "k3b-2.0.3a";
  
  src = fetchurl {
    url = "http://download.kde.org/stable/k3b/${name}.tar.xz";
    sha256 = "10f07465g9860chfnvrp9w3m686g6j9f446xgnnx7h82d1sb42rd";
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
