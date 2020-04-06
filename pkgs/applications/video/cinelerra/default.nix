{ stdenv, fetchFromGitHub, autoconf, automake, libtool
, pkgconfig, faad2, faac, a52dec, alsaLib, fftw, lame, libavc1394
, libiec61883, libraw1394, libsndfile, libvorbis, libogg, libjpeg
, libtiff, freetype, mjpegtools, x264, gettext, openexr
, libXext, libXxf86vm, libXv, libXi, libX11, libXft, xorgproto, libtheora, libpng
, libdv, libuuid, file, nasm, perl
, fontconfig, intltool }:

stdenv.mkDerivation {
  name = "cinelerra-cv-2018-05-16";

  src = fetchFromGitHub {
    owner = "ratopi";
    repo = "CinelerraCV";
    rev = "d9c0dbf4393717f0a42f4b91c3e1ed5b16f955dc";
    sha256 = "0a8kfm1v96sv6jh4568crg6nkr6n3579i9xksfj8w199s6yxzsbk";
  };

  preConfigure = ''
    find -type f -print0 | xargs --null sed -e "s@/usr/bin/perl@${perl}/bin/perl@" -i
    ./autogen.sh
    sed -i -e "s@/usr/bin/file@${file}/bin/file@" ./configure
  '';

  ## fix bug with parallel building
  preBuild = ''
    make -C cinelerra versioninfo.h
  '';
  enableParallelBuilding = true;

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

  meta = {
    description = "Video Editor";
    homepage = http://www.cinelerra.org;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    license = stdenv.lib.licenses.gpl2;
  };
}
