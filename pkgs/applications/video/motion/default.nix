{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "09xs815jsivcilpmnrx2jkcxirj4lg5kp99fkr0p2sdxw03myi95";
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
