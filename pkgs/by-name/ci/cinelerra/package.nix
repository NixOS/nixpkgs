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
  version = "2.3-unstable-2024-03-20";

  src = fetchFromGitHub {
    owner = "cinelerra-cv-team";
    repo = "cinelerra-cv";
    rev = "18a693425f78f7c4c68b5a342efce3e8db2a30dc";
    hash = "sha256-+47Xa63GoKiQzEXbxmKUwJLDIFUnzc/FfxRPXCCxzpE=";
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
    mainProgram = "cinelerracv";
    maintainers = with maintainers; [ marcweber ];
    license = licenses.gpl2Only;
    # https://github.com/cinelerra-cv-team/cinelerra-cv/issues/3
    platforms = [ "x86_64-linux" ];
  };
}
