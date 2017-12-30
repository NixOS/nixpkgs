{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libjpeg, ffmpeg }:

stdenv.mkDerivation rec {
  name = "motion-${version}";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "Motion-Project";
    repo = "motion";
    rev = "release-${version}";
    sha256 = "1prbgl9wb9q7igsb6n11c25m0p0z246fxr1q8n1vcjr4rcb65y38";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libjpeg ffmpeg ];

  meta = with stdenv.lib; {
    homepage = http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome;
    description = "Monitors the video signal from cameras";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.puffnfresh ];
  };
}
