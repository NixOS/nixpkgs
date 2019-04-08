{ stdenv, fetchgit, autoconf, automake, libtool
, pkgconfig, faad2, faac, a52dec, alsaLib, fftw, lame, libavc1394
, libiec61883, libraw1394, libsndfile, libvorbis, libogg, libjpeg
, libtiff, freetype, mjpegtools, x264, gettext, openexr
, libXext, libXxf86vm, libXv, libXi, libX11, libXft, xorgproto, libtheora, libpng
, libdv, libuuid, file, nasm, perl
, fontconfig, intltool }:

stdenv.mkDerivation {
  name = "cinelerra-unstable-2016-01-12";

  src = fetchgit {
    url = "git://git.cinelerra-cv.org/j6t/cinelerra.git";
    rev = "454be60e201c18c1fc3f1f253a6d2184fcfc94c4";
    sha256 = "1n4kshqhgnr7aivsi8dgx48phyd2nzvv4szbc82mndklvs9jfb7r";
  };

  # touch config.rpath: work around bug in automake 1.10 ?
  preConfigure = ''
    find -type f -print0 | xargs --null sed -e "s@/usr/bin/perl@${perl}/bin/perl@" -i
    touch config.rpath
    ./autogen.sh
    sed -i -e "s@/usr/bin/file@${file}/bin/file@" ./configure
  '';

  buildInputs =
    [ automake
      autoconf libtool pkgconfig file
      faad2 faac
      a52dec alsaLib   fftw lame libavc1394 libiec61883
      libraw1394 libsndfile libvorbis libogg libjpeg libtiff freetype
      mjpegtools x264 gettext openexr
      libXext libXxf86vm libXv libXi libX11 libXft xorgproto
      libtheora libpng libdv libuuid
      nasm
      perl
      fontconfig intltool
    ];

  # $ make -C cinelerra edl.o
  # edl.C:50:25: fatal error: versioninfo.h: No such file or directory
  enableParallelBuilding = false;

  meta = {
    description = "Video Editor";
    homepage = http://www.cinelerra.org;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    license = stdenv.lib.licenses.gpl2;
  };
}
