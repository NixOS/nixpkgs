{ stdenv, lib, fetchurl, writeScript, cdrtools, dvdauthor, ffmpeg, imagemagick, lame, mjpegtools, sox, transcode, vorbis-tools }:

let
  binPath = lib.makeBinPath [ cdrtools dvdauthor ffmpeg imagemagick lame mjpegtools sox transcode vorbis-tools ];

  wrapper = writeScript "dvd-slideshow.sh" ''
      #!/bin/bash
      # wrapper script for dvd-slideshow programs
      export PATH=${binPath}:$PATH

      dir=`dirname "$0"`
      exe=`basename "$0"`
      case "$exe" in
        dvd-slideshow)
          # use mpeg2enc by default as ffmpeg is known to crash.
          # run dvd-slideshow.ffmpeg to force ffmpeg.
          "$dir/dvd-slideshow.real" -mpeg2enc $@
          ;;

        dvd-slideshow.ffmpeg)
          "$dir/dvd-slideshow.real" $@
          ;;

        *)
          "$dir/$exe.real" $@
          ;;
      esac
    '';

in stdenv.mkDerivation rec {
  name = "dvd-slideshow";
  version = "0.8.4-2";
  src = fetchurl {
    url = "mirror://sourceforge/dvd-slideshow/files/${name}-${version}.tar.gz";
    sha256 = "17c09aqvippiji2sd0pcxjg3nb1mnh9k5nia4gn5lhcvngjcp1q5";
  };

  patchPhase = ''
    # fix upstream typos
    substituteInPlace dvd-slideshow \
      --replace "version='0.8.4-1'" "version='0.8.4-2'" \
      --replace "mymyecho" "myecho" 
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp dvd-slideshow         "$out/bin/dvd-slideshow.real"
    cp dvd-menu              "$out/bin/dvd-menu.real"
    cp dir2slideshow         "$out/bin/dir2slideshow.real"
    cp gallery1-to-slideshow "$out/bin/gallery1-to-slideshow.real"
    cp jigl2slideshow        "$out/bin/jigl2slideshow.real"

    cp ${wrapper} "$out/bin/dvd-slideshow.sh"
    ln -s dvd-slideshow.sh "$out/bin/dvd-slideshow"
    ln -s dvd-slideshow.sh "$out/bin/dvd-slideshow.ffmpeg"
    ln -s dvd-slideshow.sh "$out/bin/dvd-menu"
    ln -s dvd-slideshow.sh "$out/bin/dir2slideshow"
    ln -s dvd-slideshow.sh "$out/bin/gallery1-to-slideshow"
    ln -s dvd-slideshow.sh "$out/bin/jigl2slideshow"

    cp -a man "$out/"
  '';

  meta = {
    description = "Suite of command line programs that creates a slideshow-style video from groups of pictures";
    homepage = http://dvd-slideshow.sourceforge.net/wiki/Main_Page;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.robbinch ];
  };
}
