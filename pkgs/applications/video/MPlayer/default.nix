{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false
, stdenv, fetchurl, x11, freetype, zlib
, alsa ? null, libXv ? null, libtheora ? null}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;
assert theoraSupport -> libtheora != null;

stdenv.mkDerivation {
  name = "MPlayer-1.0pre7";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www2.mplayerhq.hu/MPlayer/releases/MPlayer-1.0pre7.tar.bz2;
    md5 = "5fadd6957d3aab989cd760ff38fb8fdf";
  };
  fonts = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/font-arial-iso-8859-1.tar.bz2;
    md5 = "1ecd31d17b51f16332b1fcc7da36b312";
  };

  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };

  buildInputs = [
    x11 libXv freetype zlib
    (if alsaSupport then alsa else null)
    (if xvSupport then libXv else null)
    (if theoraSupport then libtheora else null)
  ];
}
