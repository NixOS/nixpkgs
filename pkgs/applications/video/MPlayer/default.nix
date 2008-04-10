{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false, dvdnavSupport ? true
, stdenv, fetchurl, x11, freetype, freefont_ttf, zlib
, alsa ? null, libX11, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null, libdvdnav ? null
, cdparanoia ? null, cddaSupport ? true
, extraBuildInputs ? []
, extraConfigureFlags ? ""
}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;
assert theoraSupport -> libtheora != null;
assert cacaSupport -> libcaca != null;
assert xineramaSupport -> libXinerama != null;
assert randrSupport -> libXrandr != null;
assert dvdnavSupport -> libdvdnav != null;
assert cddaSupport -> cdparanoia != null;

let

  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };

  rp9codecs = (import ./rp9codecs) {
    inherit stdenv fetchurl;
  };

in

stdenv.mkDerivation {
  name = "MPlayer-1.0rc2";

  src = fetchurl {
    url = http://www1.mplayerhq.hu/MPlayer/releases/MPlayer-1.0rc2.tar.bz2;
    sha1 = "e9b496f3527c552004ec6d01d6b43f196b43ce2d";
  };

  buildInputs = [
    x11 libXv freetype zlib
    (if alsaSupport then alsa else null)
    (if xvSupport then libXv else null)
    (if theoraSupport then libtheora else null)
    (if cacaSupport then libcaca else null)
    (if xineramaSupport then libXinerama else null)
    (if randrSupport then libXrandr else null)
    (if dvdnavSupport then libdvdnav else null)
    (if cddaSupport then cdparanoia else null)
  ]
  ++ extraBuildInputs
  ;

  configureFlags = "
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav" else ""}
    --win32codecsdir=${win32codecs}
    --realcodecsdir=${rp9codecs}
    --enable-runtime-cpudetection
    --enable-x11 --with-extraincdir=${libX11}/include
    --disable-xanim
  "
  + extraConfigureFlags
  ;

  NIX_LDFLAGS = "-lX11 -lXext "  # !!! hack, necessary to get libX11/Xext in the RPATH
    + (if dvdnavSupport then "-ldvdnav" else "");

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall = "cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf";

  patches = [
    # These fix MPlayer's aspect ratio when run in a screen rotated with
    # Xrandr.
    # See: http://itdp.de/~itdp/html/mplayer-dev-eng/2005-08/msg00427.html
    #./mplayer-aspect.patch
    #./mplayer-pivot.patch
  ];

  meta = {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = "GPL";
  };
}
