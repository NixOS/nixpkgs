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
  version = "unstable-2023-01-29";

  src = fetchFromGitHub {
    owner = "cinelerra-cv-team";
    repo = "cinelerra-cv";
    rev = "bb00ac6b70fcf3cf419348b56f9b264bc01c1a89";
    sha256 = "11965kb3d7xcvlcf8p7jlzk9swk5i78x7wja4s3043wlzmqmwv0q";
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
