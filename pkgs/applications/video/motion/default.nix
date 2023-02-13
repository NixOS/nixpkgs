{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, ffmpeg, libjpeg, libmicrohttpd }:

stdenv.mkDerivation rec {
  pname = "motion";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner  = "Motion-Project";
    repo   = "motion";
    rev    = "release-${version}";
    sha256 = "sha256-3TmmLAU/muiI90hrYrctzgVbWS4rXjxzAa0ctVYKSSY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ffmpeg libjpeg libmicrohttpd ];

  meta = with lib; {
    description = "Monitors the video signal from cameras";
    homepage = "https://motion-project.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ puffnfresh veprbl ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
