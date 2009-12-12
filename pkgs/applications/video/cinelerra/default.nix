args:
with args;
args.stdenv.mkDerivation {
  name = "cinelerra-git";

  # REGION AUTO UPDATE:    { name="cinelerra"; type="git"; url="git://git.cinelerra.org/j6t/cinelerra.git"; }
  src= sourceFromHead "cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/cinelerra-9f9adf2ad5472886d5bc43a05c6aa8077cabd967.tar.gz"; sha256 = "0b264e2a770d2257550c9a23883a060afcaff12293fe43828954e7373f5f4fb4"; });
  # END

  perl = args.perl;

  # touch confi.rpath: work around bug in automake 1.10 ?
  preConfigure = ''
    find -type f -print0 | xargs --null sed -e "s@/usr/bin/perl@$perl/bin/perl@" -i
    touch config.rpath
    ./autogen.sh
    '';
  configureOptions = ["--enable-freetype2"];

  buildInputs =(with args; [
      automake
      autoconf libtool pkgconfig
      faad2 faac
      a52dec alsaLib   fftw lame libavc1394 libiec61883
      libraw1394 libsndfile libvorbis libogg libjpeg libtiff freetype
      mjpegtools x264 gettext openexr esound 
      #
      libXxf86vm libXv libXi libX11 xextproto
      libtheora libpng libdv
      nasm
      perl
      e2fsprogs
  ]);

  meta = { 
      description = "Cinelerra - Video Editor";
      homepage = http://www.cinelerra.org;
      maintainers = [lib.maintainers.marcweber];
      license = "GPLv2";
  };
}
