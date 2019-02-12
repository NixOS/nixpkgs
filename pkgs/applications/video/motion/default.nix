{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  name = "motion-${version}";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "1h359hngbkazdli7vl949r6glrq4xxs70js6n1j8jxcyw1wxian9";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with stdenv.lib; {
    description = "Monitors the video signal from cameras";
    homepage = https://motion-project.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh veprbl ];
  };
}
