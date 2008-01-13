# is this configure option of interest?
#--enable-udev-rules-dir=PATH
#                        Where to install udev rules (/etc/udev/rules.d)



# This is my config output.. Much TODO ?
#source path               /tmp/nix-31998-1/kino-1.2.0/ffmpeg
#C compiler                gcc
#make                      make
#.align is power-of-two    no
#ARCH                      x86_64 (generic)
#build suffix              -kino
#big-endian                no
#MMX enabled               yes
#CMOV enabled              no
#CMOV is fast              no
#gprof enabled             no
#debug symbols             yes
#strip symbols             yes
#optimize                  yes
#static                    yes
#shared                    no
#postprocessing support    no
#software scaler enabled   yes
#video hooking             no
#network support           no
#threading support         no
#SDL support               no
#Sun medialib support      no
#AVISynth enabled          no
#liba52 support            no
#liba52 dlopened           no
#libdts support            no
#libfaac enabled           no
#libfaad enabled           no
#faadbin enabled           no
#libgsm enabled            no
#libmp3lame enabled        no
#libnut enabled            no
#libogg enabled            no
#libtheora enabled         no
#libvorbis enabled         no
#x264 enabled              no
#XviD enabled              no
#zlib enabled              no
#AMR-NB float support      no
#AMR-NB fixed support      no
#AMR-WB float support      no
#AMR-WB IF2 support        no


args:
args.stdenv.mkDerivation {
  name = "kino-1.2.0";

  src = args.fetchurl {
    url = http://downloads.sourceforge.net/kino/kino-1.2.0.tar.gz;
    sha256 = "15q1qmii5a2zbrrrg8iba2d1rjzaisa75zvxjhrs86jwglpn4lp9";
  };

  buildInputs =(with args; [ gtk libglade libxml2 libraw1394 libsamplerate libdv 
      pkgconfig perl perlXMLParser libavc1394 libiec61883 x11 libXv gettext libX11]); # TODOoptional packages 

  #preConfigure = "
  #  grep 11 env-vars
  #  ex
  #";

  postInstall = "
    for i in $\buildInputs; do
      echo adding \$i/lib
      rpath=\$rpath:\$i/lib
    done
    echo \$buildInputs
    echo \$rpath
    patchelf --set-rpath \"\$rpath\" \"\$out/bin/\"*
  ";


  meta = { 
      description = "Kino is a non-linear DV editor for GNU/Linux";
      homepage = http://www.kinodv.org/;
      license = "GPL2";
  };
}

/*
# is this configure option of interest?
#--enable-udev-rules-dir=PATH
#                        Where to install udev rules (/etc/udev/rules.d)
args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      # TODO optional packages
      
    }; 

    extraAttrs = co : {
      name = "kino-1.2.0";

      src = args.fetchurl {
        url = http://downloads.sourceforge.net/kino/kino-1.2.0.tar.gz;
        sha256 = "15q1qmii5a2zbrrrg8iba2d1rjzaisa75zvxjhrs86jwglpn4lp9";
      };

      meta = { 
          description = "Kino is a non-linear DV editor for GNU/Linux";
          homepage = http://www.kinodv.org/;
          license = "GPL2";
    };
  };
} ) args
*/
