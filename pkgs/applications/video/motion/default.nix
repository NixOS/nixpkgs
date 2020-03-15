{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "Release-${version}";
    sha256 = "08mm7ajgs0qnrydywxxyzcll09z80crjnjkjnckdi6ljsj6s96j8";
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
