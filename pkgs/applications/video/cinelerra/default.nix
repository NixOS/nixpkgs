{ lib, stdenv, fetchFromGitHub, fetchpatch, autoconf, automake, libtool
, pkg-config, faad2, faac, a52dec, alsaLib, fftw, lame, libavc1394
, libiec61883, libraw1394, libsndfile, libvorbis, libogg, libjpeg
, libtiff, freetype, mjpegtools, x264, gettext, openexr
, libXext, libXxf86vm, libXv, libXi, libX11, libXft, xorgproto, libtheora, libpng
, libdv, libuuid, file, nasm, perl
, fontconfig, intltool }:

stdenv.mkDerivation {
  name = "cinelerra-cv-2018-05-16";

  src = fetchFromGitHub {
    owner = "cinelerra-cv-team";
    repo = "cinelerra-cv";
    rev = "d9c0dbf4393717f0a42f4b91c3e1ed5b16f955dc";
    sha256 = "0a8kfm1v96sv6jh4568crg6nkr6n3579i9xksfj8w199s6yxzsbk";
  };

  patches = [
    # avoid gcc10 error about narrowing
    (fetchpatch {
      url = "https://github.com/cinelerra-cv-team/cinelerra-cv/pull/2/commits/a1b2d9c3bd5730ec0284894f3d81892af3e77f1f.patch";
      sha256 = "1cjyv1m174dblpa1bs5dggk24h4477zqvc5sbfc0m5rpkndx5ycp";
    })
  ];

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

  nativeBuildInputs = [ automake autoconf libtool pkg-config file intltool ];
  buildInputs =
    [ faad2 faac
      a52dec alsaLib   fftw lame libavc1394 libiec61883
      libraw1394 libsndfile libvorbis libogg libjpeg libtiff freetype
      mjpegtools x264 gettext openexr
      libXext libXxf86vm libXv libXi libX11 libXft xorgproto
      libtheora libpng libdv libuuid
      nasm
      perl
      fontconfig
    ];

  meta = with lib; {
    description = "Video Editor";
    homepage = "https://www.cinelerra.org/";
    maintainers = with maintainers; [ marcweber ];
    license = licenses.gpl2Only;
  };
}
