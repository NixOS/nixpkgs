{ alsaSupport ? false
, stdenv, fetchurl, x11, freetype, alsa ? null}:

assert x11 != null && freetype != null;
assert alsaSupport -> alsa != null;

derivation {
  name = "MPlayer-1.0pre3";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/MPlayer-1.0pre3.tar.bz2;
    md5 = "998becb79417c6a14d15c07e85188b82";
  };
  fonts = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/fonts/font-arial-iso-8859-1.tar.bz2;
    md5 = "1ecd31d17b51f16332b1fcc7da36b312";
  };

  alsaSupport = alsaSupport;

  stdenv = stdenv;
  x11 = x11;
  freetype = freetype;
  alsa = if alsaSupport then alsa else null;
  win32codecs = (import ./win32codecs) {
    stdenv = stdenv;
    fetchurl = fetchurl;
  };
}
