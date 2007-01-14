{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false
, stdenv, fetchurl, x11, freetype, freefont_ttf, zlib
, alsa ? null, libX11, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null
}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;
assert theoraSupport -> libtheora != null;
assert cacaSupport -> libcaca != null;
assert xineramaSupport -> libXinerama != null;
assert randrSupport -> libXrandr != null;

let

  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };

in

stdenv.mkDerivation {
  name = "MPlayer-1.0rc1try2";

  src = fetchurl {
    url = http://www1.mplayerhq.hu/MPlayer/releases/MPlayer-1.0rc1.tar.bz2;
    sha1 = "a450c0b0749c343a8496ba7810363c9d46dfa73c";
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

  configureFlags = "
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    --with-win32libdir=${win32codecs}
    --with-reallibdir=${win32codecs}
    --enable-runtime-cpudetection
    --enable-x11 --with-x11libdir=/no-such-dir --with-extraincdir=${libX11}/include
    --disable-xanim
  ";

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall = "cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf";

  patches = [
    # These fix MPlayer's aspect ratio when run in a screen rotated with
    # Xrandr.
    # See: http://itdp.de/~itdp/html/mplayer-dev-eng/2005-08/msg00427.html
    ./mplayer-aspect.patch
    ./mplayer-pivot.patch

    # Security fix.
    ./asmrules-fix.patch
  ];

  meta = {
    description = "A movie player that supports many video formats";
  };
}
