{ xvSupport ? true
, stdenv, fetchurl, perl, x11, libXv, wxGTK
#libdvdcss, libdvdplay
, zlib, mpeg2dec, a52dec, libmad, ffmpeg, alsa
}:

#assert libdvdplay.libdvdread.libdvdcss == libdvdcss;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "vlc-0.8.5";

  src = fetchurl {
    url = http://ftp.snt.utwente.nl/pub/software/videolan/vlc/0.8.5/vlc-0.8.5.tar.bz2;
    md5 = "16bb5bf87ed94879a8eb7b0ff9b4f16f";
  };

  buildInputs = [
    perl x11 wxGTK /* libdvdcss libdvdplay libdvdplay.libdvdread */
    zlib mpeg2dec a52dec libmad ffmpeg alsa
    (if xvSupport then libXv else null)
  ];

  configureFlags = "--enable-alsa";
}
