{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libjpeg, ffmpeg }:

stdenv.mkDerivation rec {
  name = "motion-${version}";
  version = "4.0.1";
  src = fetchFromGitHub {
    owner = "Motion-Project";
    repo = "motion";
    rev = "release-${version}";
    sha256 = "172bn2ny5r9fcb4kn9bjq3znpgl8ai84w4b99vhk5jggp2haa3bb";
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
