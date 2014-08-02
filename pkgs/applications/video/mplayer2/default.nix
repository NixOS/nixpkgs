{ stdenv, fetchurl, fetchgit, freetype, pkgconfig, yasm, freefont_ttf, ffmpeg, libass
, python3, docutils, which
, x11Support ? true, libX11 ? null, libXext ? null, mesa ? null, libXxf86vm ? null
, xineramaSupport ? true, libXinerama ? null
, xvSupport ? true, libXv ? null
, alsaSupport ? true, alsaLib ? null
, screenSaverSupport ? true, libXScrnSaver ? null
, vdpauSupport ? true, libvdpau ? null
, dvdnavSupport ? true, libdvdnav ? null
, bluraySupport ? true, libbluray ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, jackaudioSupport ? false, jack2 ? null
, pulseSupport ? true, pulseaudio ? null
, bs2bSupport ? false, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
, useUnfreeCodecs ? false
}:

assert x11Support -> (libX11 != null && libXext != null && mesa != null && libXxf86vm != null);
assert xineramaSupport -> (libXinerama != null && x11Support);
assert xvSupport -> (libXv != null && x11Support);
assert alsaSupport -> alsaLib != null;
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;
assert dvdnavSupport -> libdvdnav != null;
assert bluraySupport -> libbluray != null;
assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert jackaudioSupport -> jack2 != null;
assert pulseSupport -> pulseaudio != null;
assert bs2bSupport -> libbs2b != null;
assert libpngSupport -> libpng != null;

let

  codecs_src =
    let
      dir = http://www.mplayerhq.hu/MPlayer/releases/codecs/;
    in
    if stdenv.system == "i686-linux" then fetchurl {
      url = "${dir}/essential-20071007.tar.bz2";
      sha256 = "18vls12n12rjw0mzw4pkp9vpcfmd1c21rzha19d7zil4hn7fs2ic";
    } else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "${dir}/essential-amd64-20071007.tar.bz2";
      sha256 = "13xf5b92w1ra5hw00ck151lypbmnylrnznq9hhb0sj36z5wz290x";
    } else if stdenv.system == "powerpc-linux" then fetchurl {
      url = "${dir}/essential-ppc-20071007.tar.bz2";
      sha256 = "18mlj8dp4wnz42xbhdk1jlz2ygra6fbln9wyrcyvynxh96g1871z";
    } else null;

  codecs = if codecs_src != null then stdenv.mkDerivation {
    name = "MPlayer-codecs-essential-20071007";

    src = codecs_src;

    installPhase = ''
      mkdir $out
      cp -prv * $out
    '';

    meta.license = stdenv.lib.licenses.unfree;
  } else null;

in

stdenv.mkDerivation rec {
  name = "mplayer2-20130428";

  src = fetchgit {
    url = "git://git.mplayer2.org/mplayer2.git";
    rev = "6c87a981baa4972fd71c25dfddea017b5a972e89";
    sha256 = "b09c1331141dd0939dfa424ae14dc0bdf82c8a72bb32c78e3ad15e3ee1d2c851";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure

    sed -i '/stdlib/a#include <ctype.h>/' sub/sub*.c
  '';

  buildInputs = with stdenv.lib;
    [ freetype pkgconfig ffmpeg libass docutils which ]
    ++ optionals x11Support [ libX11 libXext mesa libXxf86vm ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional xineramaSupport libXinerama
    ++ optionals dvdnavSupport [ libdvdnav libdvdnav.libdvdread ]
    ++ optional bluraySupport libbluray
    ++ optional jackaudioSupport jack2
    ++ optional pulseSupport pulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
    ++ optional bs2bSupport libbs2b
    ++ optional libpngSupport libpng
    ;

  nativeBuildInputs = [ yasm python3 ];

  postConfigure = ''
    patchShebangs TOOLS
  '';

  configureFlags = with stdenv.lib;
    ''
      ${optionalString (useUnfreeCodecs && codecs != null) "--codecsdir=${codecs}"}
      ${optionalString (stdenv.isi686 || stdenv.isx86_64) "--enable-runtime-cpudetection"}
      ${optionalString dvdnavSupport "--extra-ldflags=-ldvdread"}
      ${if xvSupport then "--enable-xv" else "--disable-xv"}
      ${if x11Support then "--enable-x11 --enable-gl --extra-cflags=-I{libx11}/include"
		else "--disable-x11 --disable-gl"}
      --disable-xvid
      --disable-ossaudio
    '';

  NIX_LDFLAGS = stdenv.lib.optionalString x11Support "-lX11 -lXext";

  enableParallelBuilding = true;

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall =
    ''
      mkdir -p $out/share/mplayer
      cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
    '';

  meta = {
    description = "A movie player that supports many video formats (MPlayer fork)";
    homepage = "http://mplayer2.org";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
