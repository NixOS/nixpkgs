{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "01yy4pdgd4wa97bpw27zn5zik9iz719m1jiwkk9lb7m2a2951dhc";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with stdenv.lib; {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh veprbl ];
    platforms = platforms.unix;
  };
}
