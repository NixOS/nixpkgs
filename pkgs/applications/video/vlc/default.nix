{ xvSupport ? true
, stdenv, fetchurl, perl, x11, libXv, wxGTK
, libdvdread, libdvdnav, libdvdcss
, zlib, mpeg2dec, a52dec, libmad, ffmpeg, alsa
}:

assert libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.6c";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.8.6c/vlc-0.8.6c.tar.bz2;
    sha256 = "1bmngn66i527vw9g5xnhlpz64xl5gch3j3l6y5d727rcpmxlvhjz";
  };

  buildInputs = [
    perl x11 wxGTK 
    zlib mpeg2dec a52dec libmad ffmpeg alsa
    libdvdread # <- for "simple" DVD playback
    libdvdnav libdvdcss # <- for DVD playback with menus
    (if xvSupport then libXv else null)
  ];

  # Ensure that libdvdcss will be found without having to set LD_LIBRARY_PATH.
  NIX_LDFLAGS = "-ldvdcss";

  configureFlags = "--enable-alsa";

  meta = {
    description = "Cross-platform media player and streaming server";
  };
}
