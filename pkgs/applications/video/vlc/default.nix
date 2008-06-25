{ xvSupport ? true
, stdenv, fetchurl, perl, x11, libXv, wxGTK
, libdvdread, libdvdnav, libdvdcss
, zlib, mpeg2dec, a52dec, libmad, ffmpeg, alsa
}:

assert libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.6h";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.8.6h/vlc-0.8.6h.tar.bz2;
    sha256 = "08bj6ndxj0f7jdsif43535qyavpy13wni93z7c2790i2d748gvah";
  };

  buildInputs = [
    perl x11 wxGTK 
    zlib mpeg2dec a52dec libmad ffmpeg alsa
    libdvdread # <- for "simple" DVD playback
    libdvdnav libdvdcss # <- for DVD playback with menus
  ] ++ stdenv.lib.optional xvSupport libXv;

  # Ensure that libdvdcss will be found without having to set LD_LIBRARY_PATH.
  NIX_LDFLAGS = "-ldvdcss";

  configureFlags = "--enable-alsa";

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
  };
}
