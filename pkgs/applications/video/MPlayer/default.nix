{ alsaSupport ? false, xvSupport ? true
, stdenv, fetchurl, x11, libXv, freetype, zlib, alsa ? null}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;

stdenv.mkDerivation {
  name = "MPlayer-1.0pre6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/MPlayer-1.0pre6a.tar.bz2;
    md5 = "a812d945b884c2e2fa7f90c57cd76bff";
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
  ];
}
