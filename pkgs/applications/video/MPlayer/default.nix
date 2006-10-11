{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false
, stdenv, fetchurl, x11, freetype, zlib
, alsa ? null, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null
}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;
assert theoraSupport -> libtheora != null;
assert cacaSupport -> libcaca != null;
assert xineramaSupport -> libXinerama != null;
assert randrSupport -> libXrandr != null;

stdenv.mkDerivation {
  name = "MPlayer-1.0pre8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www4.mplayerhq.hu/MPlayer/releases/MPlayer-1.0pre8.tar.bz2;
    md5 = "f82bb2bc51b6cd5e5dd96f88f6f98582";
  };
  fonts = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/font-arial-iso-8859-1.tar.bz2;
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
    (if cacaSupport then libcaca else null)
    (if xineramaSupport then libXinerama else null)
    (if randrSupport then libXrandr else null)
  ];

  configureFlags = if cacaSupport then "--enable-caca" else "--disable-caca";

  # These fix MPlayer's aspect ratio when run in a screen rotated with
  # Xrandr.
  # See: http://itdp.de/~itdp/html/mplayer-dev-eng/2005-08/msg00427.html
  patches = [./mplayer-aspect.patch ./mplayer-pivot.patch];

  meta = {
    description = "A movie player that supports many video formats";
  };
}
