{ xvSupport ? true
, stdenv, fetchurl, x11, libXv, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert libdvdplay.libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.7.2";

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/vlc-0.7.2.tar.gz;
    md5 = "25dfcc804cb92f46c0b64ce1466515cc";
  };

  buildInputs = [
    x11 wxGTK libdvdcss libdvdplay libdvdplay.libdvdread
    mpeg2dec a52dec libmad alsa
    (if xvSupport then libXv else null)
  ];

  configureFlags = "--disable-ffmpeg --enable-alsa";
}
