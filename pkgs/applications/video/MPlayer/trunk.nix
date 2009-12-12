# the hompepage even recommends using trunk
{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false, dvdnavSupport ? true
, stdenv, fetchurl, x11, freetype, freefont_ttf, zlib
, alsa ? null, libX11, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null, libdvdnav ? null, jackaudio ? null
, cdparanoia ? null, cddaSupport ? true, jackaudioSupport ? true
, mesa, pkgconfig
, sourceFromHead
}:

assert alsaSupport -> alsa != null;
assert xvSupport -> libXv != null;
assert theoraSupport -> libtheora != null;
assert cacaSupport -> libcaca != null;
assert xineramaSupport -> libXinerama != null;
assert randrSupport -> libXrandr != null;
assert dvdnavSupport -> libdvdnav != null;
assert cddaSupport -> cdparanoia != null;
assert jackaudioSupport -> jackaudio != null;

let

  win32codecs = (import ./win32codecs) {
    inherit stdenv fetchurl;
  };

  rp9codecs = (import ./rp9codecs) {
    inherit stdenv fetchurl;
  };

in

stdenv.mkDerivation {

  name = "mplayer-trunk";

  # REGION AUTO UPDATE:     { name="MPlayer"; type = "svn"; url="svn://svn.mplayerhq.hu/mplayer/trunk"; }
  src= sourceFromHead "MPlayer-29990.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/MPlayer-29990.tar.gz"; sha256 = "8d9ac59e7cc3e2bc9ca46281ac2c268d460e041aceac056b600205c8c5235169"; });
  # END

  buildInputs =
    [x11 libXv freetype zlib mesa pkgconfig]
    ++ stdenv.lib.optional alsaSupport alsa
    ++ stdenv.lib.optional xvSupport libXv
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional cacaSupport libcaca
    ++ stdenv.lib.optional xineramaSupport libXinerama
    ++ stdenv.lib.optional randrSupport libXrandr
    ++ stdenv.lib.optionals dvdnavSupport [libdvdnav libdvdnav.libdvdread]
    ++ stdenv.lib.optional cddaSupport cdparanoia
    ++ stdenv.lib.optional jackaudioSupport jackaudio;

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    --win32codecsdir=${win32codecs}
    --realcodecsdir=${rp9codecs}
    --enable-runtime-cpudetection
    --enable-x11
    --disable-xanim
    --disable-ivtv
  '';

  NIX_LDFLAGS = "-lX11 -lXext";

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall = ''
    ensureDir $out/share/mplayer
    cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
  '';

  meta = {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = "GPL";
  };
}
