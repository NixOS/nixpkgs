{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, cairo, ffmpeg_3, ffms, libjpeg, log4cpp, pango
, avxeditSupport ? false, qt4 ? null
}:

let
  inherit (lib) enableFeature optional;
in

stdenv.mkDerivation {
  pname = "avxsynth";
  version = "2015-04-07";

  src = fetchFromGitHub {
    owner = "avxsynth";
    repo = "avxsynth";
    rev = "80dcb7ec8d314bc158130c92803308aa8e5e9242";
    sha256 = "0kckggvgv68b0qjdi7ms8vi97b46dl63n60qr96d2w67lf2nk87z";
  };

  configureFlags = [
    "--enable-autocrop"
    "--enable-framecapture"
    "--enable-subtitle"
    "--enable-ffms2"
    (enableFeature avxeditSupport "avxedit")
    "--with-jpeg=${libjpeg.out}/lib"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ cairo ffmpeg_3 ffms libjpeg log4cpp pango ]
    ++ optional avxeditSupport qt4;

  meta = with lib; {
    description = "A script system that allows advanced non-linear editing";
    homepage = "https://github.com/avxsynth/avxsynth";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
    broken = true; # 2018-04-10
  };
}
