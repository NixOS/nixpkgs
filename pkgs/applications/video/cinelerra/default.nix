{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, faad2
, faac
, a52dec
, alsa-lib
, fftw
, lame
, libavc1394
, libiec61883
, libraw1394
, libsndfile
, libvorbis
, libogg
, libjpeg
, libtiff
, freetype
, mjpegtools
, x264
, gettext
, openexr
, libXext
, libXxf86vm
, libXv
, libXi
, libX11
, libXft
, xorgproto
, libtheora
, libpng
, libdv
, libuuid
, file
, nasm
, perl
, fontconfig
, intltool
}:

stdenv.mkDerivation {
  pname = "cinelerra-cv";
  version = "unstable-2021-02-14";

  src = fetchFromGitHub {
    owner = "cinelerra-cv-team";
    repo = "cinelerra-cv";
    rev = "7d0e8ede557d0cdf3606e0a8d97166a22f88d89e";
    sha256 = "0n84y2wp47y89drc48cm1609gads5c6saw6c6bqcf5c5wcg1yfbj";
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

  nativeBuildInputs = [ automake autoconf libtool pkg-config file intltool ];

  buildInputs = [
    faad2
    faac
    a52dec
    alsa-lib
    fftw
    lame
    libavc1394
    libiec61883
    libraw1394
    libsndfile
    libvorbis
    libogg
    libjpeg
    libtiff
    freetype
    mjpegtools
    x264
    gettext
    openexr
    libXext
    libXxf86vm
    libXv
    libXi
    libX11
    libXft
    xorgproto
    libtheora
    libpng
    libdv
    libuuid
    nasm
    perl
    fontconfig
  ];

  meta = with lib; {
    description = "Professional video editing and compositing environment (community version)";
    homepage = "http://cinelerra-cv.wikidot.com/";
    maintainers = with maintainers; [ marcweber ];
    license = licenses.gpl2Only;
  };
}
