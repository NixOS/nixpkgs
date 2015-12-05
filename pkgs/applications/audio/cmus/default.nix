{ stdenv, fetchFromGitHub, ncurses, pkgconfig, alsaLib, flac, libmad, ffmpeg, libvorbis, libmpc, mp4v2, libcue, libpulseaudio}:

stdenv.mkDerivation rec {
  name = "cmus-${version}";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner  = "cmus";
    repo   = "cmus";
    rev    = "0306cc74c5073a85cf8619c61da5b94a3f863eaa";
    sha256 = "18w9mznb843nzkrcqvshfha51mlpdl92zlvb5wfc5dpgrbf37728";
  };

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad ffmpeg libvorbis libmpc mp4v2 libcue libpulseaudio ];

  meta = {
    description = "Small, fast and powerful console music player for Linux and *BSD";
    homepage = https://cmus.github.io/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.oxij ];
  };
}
