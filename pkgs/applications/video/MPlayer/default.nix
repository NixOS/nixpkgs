{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false, dvdnavSupport ? true
, stdenv, fetchurl, x11, freetype, freefont_ttf, zlib
, alsa ? null, libX11, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null, libdvdnav ? null
, cdparanoia ? null, cddaSupport ? true
, mesa
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
  name = "MPlayer-1.0rc2-r28450";

  src = fetchurl {
    url = mirror://gentoo/distfiles/mplayer-1.0_rc2_p28450.tar.bz2;
    sha256 = "0cbils58mq20nablywgjfpfx2pzjgnhin23sb8k1s5h2rxgvi3vf";
  };

  buildInputs =
    [x11 libXv freetype zlib mesa]
    ++ stdenv.lib.optional alsaSupport alsa
    ++ stdenv.lib.optional xvSupport libXv
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional cacaSupport libcaca
    ++ stdenv.lib.optional xineramaSupport libXinerama
    ++ stdenv.lib.optional randrSupport libXrandr
    ++ stdenv.lib.optionals dvdnavSupport [libdvdnav libdvdnav.libdvdread]
    ++ stdenv.lib.optional cddaSupport cdparanoia;

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    --win32codecsdir=${win32codecs}
    --realcodecsdir=${rp9codecs}
    --enable-runtime-cpudetection
    --enable-x11 --with-extraincdir=${libX11}/include
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
