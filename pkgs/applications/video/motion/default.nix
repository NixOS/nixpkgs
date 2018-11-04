{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  name = "motion-${version}";
  version = "4.2";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "0c0q6dl4v561m5y8bp0c0h4p3s52fjgcdnsrrf5ygdi288d3rfxv";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with stdenv.lib; {
    description = "Monitors the video signal from cameras";
    homepage = https://motion-project.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
