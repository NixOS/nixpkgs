{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "sha256-uKEgTQhpslOCfNj8z95/DK4M1Gx4SMRjl1/KPh5KHuc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with lib; {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh veprbl ];
    platforms = platforms.unix;
  };
}
