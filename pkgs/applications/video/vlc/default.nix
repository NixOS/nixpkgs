{ stdenv, fetchurl, x11, wxGTK, libdvdcss, libdvdplay
, mpeg2dec, a52dec, libmad, alsa}:

assert x11 != null && wxGTK != null && libdvdcss != null
  && libdvdplay != null && mpeg2dec != null && a52dec != null
  && libmad != null && alsa != null;
assert libdvdplay.libdvdread.libdvdcss == libdvdcss;

stdenv.mkDerivation {
  name = "vlc-0.7.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.7.0/vlc-0.7.0.tar.gz;
    md5 = "05efef68528892ca933585c7db0842e3";
  };

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
