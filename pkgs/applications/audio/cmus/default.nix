{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, ffmpeg, libvorbis, mpc, mp4v2 }:

stdenv.mkDerivation rec {
  name = "cmus-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/cmus/cmus-v${version}.tar.bz2";
    sha256 = "1pwd3jifv12yr0yr77hsv5c9y8ay6kn2b5a3s5i8v2c882vgl890";
  };

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad ffmpeg libvorbis mpc mp4v2 ];

  meta = {
    description = "cmus is a small, fast and powerful console music player for Linux and *BSD";
    homepage = http://cmus.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
