{ alsaSupport ? false, xvSupport ? true
, stdenv, fetchurl, x11, libXv, freetype, zlib, alsa ? null}:

assert x11 != null && freetype != null;
assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "MPlayer-1.0pre4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/MPlayer-1.0pre4.tar.bz2;
    md5 = "83ebac0f05b192516a41fca2350ca01a";
  };
  fonts = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/fonts/font-arial-iso-8859-1.tar.bz2;
    md5 = "1ecd31d17b51f16332b1fcc7da36b312";
  };

  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };

  buildInputs = [
    x11 libXv freetype zlib
    (if alsaSupport then alsa else null)
    (if xvSupport then libXv else null)
  ];
}
