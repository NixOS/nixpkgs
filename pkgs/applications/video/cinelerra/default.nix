{ stdenv, fetchgit, sourceFromHead, autoconf, automake, libtool
, pkgconfig, faad2, faac, a52dec, alsaLib, fftw, lame, libavc1394
, libiec61883, libraw1394, libsndfile, libvorbis, libogg, libjpeg
, libtiff, freetype, mjpegtools, x264, gettext, openexr
, libXext, libXxf86vm, libXv, libXi, libX11, xextproto, libtheora, libpng
, libdv, libuuid, file, nasm, perl }:

stdenv.mkDerivation {
  name = "cinelerra-git";

  # # REGION AUTO UPDATE:    { name="cinelerra"; type="git"; url="git://git.cinelerra.org/j6t/cinelerra.git"; }
  # src= sourceFromHead "cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"
  #              (fetchurl { url = "http://mawercer.de/~nix/repos/cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"; sha256 = "0b264e2a770d2257550c9a23883a060afcaff12293fe43828954e7373f5f4fb4"; });
  # # END

  src = fetchgit {
    url = "git://git.cinelerra-cv.org/j6t/cinelerra.git";
    rev = "01dc4375a0fb65d10dd95151473d0e195239175f";
    sha256 = "0grz644vrnajhxn96x05a3rlwrbd20yq40sw3y5yg7bvi96900gf";
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
      libXext libXxf86vm libXv libXi libX11 xextproto
      libtheora libpng libdv libuuid
      nasm
      perl
    ];

  meta = {
    description = "Video Editor";
    homepage = http://www.cinelerra.org;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    license = stdenv.lib.licenses.gpl2;
  };
}
