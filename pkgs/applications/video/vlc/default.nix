{ stdenv, fetchurl, x11, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert !isNull x11 && !isNull wxGTK && !isNull libdvdcss
  && !isNull libdvdplay && !isNull mpeg2dec && !isNull a52dec
  && !isNull libmad && !isNull alsa;
assert libdvdplay.libdvdread.libdvdcss == libdvdcss;

derivation {
  name = "vlc-0.7.0";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.7.0/vlc-0.7.0.tar.gz;
    md5 = "05efef68528892ca933585c7db0842e3";
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
