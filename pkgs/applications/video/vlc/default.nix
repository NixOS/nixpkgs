{ xvSupport ? true
, stdenv, fetchurl, x11, libXv, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert libdvdplay.libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.5";

  src = fetchurl {
    url = http://ftp.snt.utwente.nl/pub/software/videolan/vlc/0.8.5/vlc-0.8.5.tar.gz;
    md5 = "90d19a5ba2ef2e03e6062fadc2e810d2";
  };

  buildInputs = [
    x11 wxGTK libdvdcss libdvdplay libdvdplay.libdvdread
    mpeg2dec a52dec libmad alsa
    (if xvSupport then libXv else null)
  ];

  configureFlags = "--disable-ffmpeg --enable-alsa";
}
