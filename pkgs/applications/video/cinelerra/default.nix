{ stdenv, fetchgit, sourceFromHead, autoconf, automake, libtool
, pkgconfig, faad2, faac, a52dec, alsaLib, fftw, lame, libavc1394
, libiec61883, libraw1394, libsndfile, libvorbis, libogg, libjpeg
, libtiff, freetype, mjpegtools, x264, gettext, openexr
, libXext, libXxf86vm, libXv, libXi, libX11, libXft, xextproto, libtheora, libpng
, libdv, libuuid, file, nasm, perl
, fontconfig, intltool }:

stdenv.mkDerivation {
  name = "cinelerra-git";

  # # REGION AUTO UPDATE:    { name="cinelerra"; type="git"; url="git://git.cinelerra.org/j6t/cinelerra.git"; }
  # src= sourceFromHead "cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"
  #              (fetchurl { url = "http://mawercer.de/~nix/repos/cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"; sha256 = "0b264e2a770d2257550c9a23883a060afcaff12293fe43828954e7373f5f4fb4"; });
  # # END

  src = fetchgit {
    url = "git://git.cinelerra-cv.org/j6t/cinelerra.git";
    # 2.3
    #rev = "58ef118e63bf2fac8c99add372c584e93b008bae";
    #sha256 = "1wx8c9rvh4y7fgg39lb02cy3sanms8a4fayr70jbhcb4rp691lph";
    # master 22 nov 2016
    #rev = "dbc22e0f35a9e8c274b06d4075b51dc9bace34aa";
    #sha256 = "0c76j98ws1x2s5hzcdlykxm2bi7987d9nanka428xj62id0grla5";

    # j6t/cinelerra.git
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
      libXext libXxf86vm libXv libXi libX11 libXft xextproto
      libtheora libpng libdv libuuid
      nasm
      perl
      fontconfig intltool
    ];

  # Note: the build may fail with e.g.:
  #   CXX      edl.o
  # edl.C:50:25: fatal error: versioninfo.h: No such file or directory
  #  #include "versioninfo.h"
  enableParallelBuilding = true;

  meta = {
    description = "Video Editor";
    homepage = http://www.cinelerra.org;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    license = stdenv.lib.licenses.gpl2;
  };
}
