{ stdenv, fetchurl, x11, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert !isNull x11 && !isNull wxGTK && !isNull libdvdcss
  && !isNull libdvdplay && !isNull mpeg2dec && !isNull a52dec
  && !isNull libmad && !isNull alsa;
assert libdvdplay.libdvdread.libdvdcss == libdvdcss;

derivation {
  name = "vlc-0.6.2";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.videolan.org/pub/videolan/vlc/0.6.2/vlc-0.6.2.tar.gz;
    md5 = "619a45ca360d4a7bf935cb5ffd69989d";
  };

  stdenv = stdenv;
  x11 = x11;
  wxGTK = wxGTK;
  libdvdcss = libdvdcss;
  libdvdplay = libdvdplay;
  libdvdread = libdvdplay.libdvdread;
  mpeg2dec = mpeg2dec;
  a52dec = a52dec;
  libmad = libmad;
  alsa = alsa;
}
