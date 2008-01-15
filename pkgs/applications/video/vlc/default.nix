{ xvSupport ? true
, stdenv, fetchurl, perl, x11, libXv, wxGTK
, libdvdread, libdvdnav, libdvdcss
, zlib, mpeg2dec, a52dec, libmad, ffmpeg, alsa
}:

assert libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.6d";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.8.6d/vlc-0.8.6d.tar.bz2;
    sha256 = "019jw9cp7fbmhbmlbwvjgpamxwx0rdajyxab2sbmh4n6v04fl266";
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
    homepage = http://www.videolan.org/vlc/;
  };
}
