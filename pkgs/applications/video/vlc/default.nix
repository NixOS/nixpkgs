{ xvSupport ? true
, stdenv, fetchurl, x11, libXv, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert x11 != null && wxGTK != null && libdvdcss != null
  && libdvdplay != null && mpeg2dec != null && a52dec != null
  && libmad != null && alsa != null;
assert libdvdplay.libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.7.1";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.7.1/vlc-0.7.1.tar.gz;
    md5 = "faa5e3162a3e9b3a3d8c3dcc06f70911";
  };

  buildInputs = [
    x11 wxGTK libdvdcss libdvdplay libdvdplay.libdvdread
    mpeg2dec a52dec libmad alsa
    (if xvSupport then libXv else null)
  ];

  configureFlags = "--disable-ffmpeg --enable-alsa";
}
