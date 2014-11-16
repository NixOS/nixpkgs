{ stdenv, fetchgit, ncurses, pkgconfig, alsaLib, flac, libmad, ffmpeg, libvorbis, mpc, mp4v2, libcue, pulseaudio}:

stdenv.mkDerivation rec {
  name = "cmus-${version}";
  version = "2.6.0";

  src = fetchgit {
    url = https://github.com/cmus/cmus.git;
    rev = "46b71032da827d22d4fae5bf2afcc4c9afef568c";
    sha256 = "1hkqifll5ryf3ljp3w1dxz1p8m6rk34fpazc6vwavis6ga310hka";
  };

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad ffmpeg libvorbis mpc mp4v2 libcue pulseaudio ];

  meta = {
    description = "Small, fast and powerful console music player for Linux and *BSD";
    homepage = https://cmus.github.io/;
    license = stdenv.lib.licenses.gpl2;
  };
}
