{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  name = "motion-${version}";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "05c1gx75xy2hw49x6vkydvwxbr80kipsc3nr906k3hq8735svx6f";
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
