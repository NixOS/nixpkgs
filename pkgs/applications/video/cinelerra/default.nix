args:
args.stdenv.mkDerivation {
  name = "cinelerra-git";

  src = args.sourceByName "cinelerra";

  perl = args.perl;

  preConfigure = ''
    find -type f -print0 | xargs --null sed -e "s@/usr/bin/perl@$perl/bin/perl@" -i
    ./autogen.sh
    '';
  configureOptions = ["--enable-freetype2"];

  buildInputs =(with args; [
      automake autoconf libtool pkgconfig
      faad2 faac
      a52dec alsaLib   fftw lame libavc1394 libiec61883
      libraw1394 libsndfile libvorbis libogg libjpeg libtiff freetype
      mjpegtools x264 gettext openexr esound 
      #
      libXxf86vm libXv
      libtheora libpng libdv
      nasm
      perl
      e2fsprogs
  ]);

  meta = { 
      description = "Cinelerra - Video Editor";
      homepage = http://www.cinelerra.org;
      license = "GPLv2";
  };
}
