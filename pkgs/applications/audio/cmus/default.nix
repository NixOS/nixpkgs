{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, ffmpeg, libvorbis, mpc, mp4v2 }:

stdenv.mkDerivation rec {
  name = "cmus-2.3.3";

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad ffmpeg libvorbis mpc mp4v2 ];

  src = fetchurl {
    url = mirror://sourceforge/cmus/cmus-v2.3.3.tar.bz2;
    md5 = "220e875e4210a6b54882114ef7094a79";
  };

  meta = {
    description = "cmus is a small, fast and powerful console music player for Linux and *BSD";
    homepage = http://cmus.sourceforge.net;
    license = "GPLv2";
  };
}
