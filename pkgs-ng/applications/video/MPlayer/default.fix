{ alsaSupport ? false
, stdenv, fetchurl, x11, freetype, alsa ? null}:

assert !isNull x11 && !isNull freetype;
assert alsaSupport -> !isNull alsa;

derivation {
  name = "MPlayer-1.0pre2";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/MPlayer-1.0pre2.tar.bz2;
    md5 = "a60c179468f85e83e3f9e1922e81ad64";
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
