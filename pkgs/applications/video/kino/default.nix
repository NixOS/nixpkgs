# is this configure option of interest?
#--enable-udev-rules-dir=PATH
#                        Where to install udev rules (/etc/udev/rules.d)

#TODO shared version?


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

{ stdenv, fetchurl, gtk2, libglade, libxml2, libraw1394, libsamplerate, libdv
, pkgconfig, perl, perlXMLParser, libavc1394, libiec61883, libXv, gettext
, libX11, glib, cairo, intltool, ffmpeg, libv4l
}:

stdenv.mkDerivation {
  name = "kino-1.3.4";

  src = fetchurl {
    url = mirror://sourceforge/kino/kino-1.3.4.tar.gz;
    sha256 = "020s05k0ma83rq2kfs8x474pqicaqp9spar81qc816ddfrnh8k8i";
  };

  buildInputs = [ gtk2 libglade libxml2 libraw1394 libsamplerate libdv
      pkgconfig perl perlXMLParser libavc1394 libiec61883 intltool libXv gettext libX11 glib cairo ffmpeg libv4l ]; # TODOoptional packages 

  configureFlags = [ "--enable-local-ffmpeg=no" ];

  hardeningDisable = [ "format" ];

  patches = [ ./kino-1.3.4-v4l1.patch ./kino-1.3.4-libav-0.7.patch ./kino-1.3.4-libav-0.8.patch ]; #./kino-1.3.4-libavcodec-pkg-config.patch ];

  postInstall = "
    rpath=`patchelf --print-rpath \$out/bin/kino`;
    for i in $\buildInputs; do
      echo adding \$i/lib
      rpath=\$rpath\${rpath:+:}\$i/lib
    done
    for i in \$out/bin/*; do
      patchelf --set-rpath \"\$rpath\" \"\$i\"
    done
  ";

  meta = {
      description = "Non-linear DV editor for GNU/Linux";
      homepage = http://www.kinodv.org/;
      license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
