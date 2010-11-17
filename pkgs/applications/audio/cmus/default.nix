{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, ffmpeg, libvorbis, mpc, mp4v2 }:

stdenv.mkDerivation rec {
  name = "cmus-${version}";
  version = "2.3.3";

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad ffmpeg libvorbis mpc mp4v2 ];

  src = fetchurl {
    url = "mirror://sourceforge/cmus/cmus-v${version}.tar.bz2";
    sha256 = "13hc5d7h2ayjwnip345hc59rpjj9fgrp1i5spjw3s14prdqr733v";
  };

  meta = {
    description = "cmus is a small, fast and powerful console music player for Linux and *BSD";
    homepage = http://cmus.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
