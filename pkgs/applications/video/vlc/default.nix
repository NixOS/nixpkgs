{ xvSupport ? true
, stdenv, fetchurl, perl, x11, libXv, wxGTK
, libdvdread, libdvdnav, libdvdcss
, zlib, mpeg2dec, a52dec, libmad, ffmpeg, alsa
}:

assert libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.5";

  src = fetchurl {
    url = http://ftp.snt.utwente.nl/pub/software/videolan/vlc/0.8.5/vlc-0.8.5.tar.bz2;
    md5 = "16bb5bf87ed94879a8eb7b0ff9b4f16f";
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
