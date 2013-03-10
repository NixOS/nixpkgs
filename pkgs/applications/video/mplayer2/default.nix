{ stdenv, fetchurl, fetchgit, freetype, pkgconfig, yasm, freefont_ttf, ffmpeg, libass
, python3, docutils, which
, x11Support ? true, libX11 ? null, libXext ? null, mesa ? null
, xineramaSupport ? true, libXinerama ? null
, xvSupport ? true, libXv ? null
, alsaSupport ? true, alsaLib ? null
, screenSaverSupport ? true, libXScrnSaver ? null
, vdpauSupport ? true, libvdpau ? null
, dvdnavSupport ? true, libdvdnav ? null
, bluraySupport ? true, libbluray ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, jackaudioSupport ? false, jackaudio ? null
, pulseSupport ? true, pulseaudio ? null
# For screenshots
, libpngSupport ? true, libpng ? null
, useUnfreeCodecs ? false
}:

assert x11Support -> (libX11 != null && libXext != null && mesa != null);
assert xineramaSupport -> (libXinerama != null && x11Support);
assert xvSupport -> (libXv != null && x11Support);
assert alsaSupport -> alsaLib != null;
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;
assert dvdnavSupport -> libdvdnav != null;
assert bluraySupport -> libbluray != null;
assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert jackaudioSupport -> jackaudio != null;
assert pulseSupport -> pulseaudio != null;
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

    meta.license = "unfree";
  } else null;

in

stdenv.mkDerivation rec {
  name = "mplayer2-20130130";

  src = fetchgit {
    url = "git://git.mplayer2.org/mplayer2.git";
    rev = "d3c580156c0b8777ff082426ebd61bb7ffe0c225";
    sha256 = "1akf2mb2zklz609ks555vjvcs1gw8nwg5kbb9jwra8c4v1dfyhys";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure
  '';

  buildInputs = with stdenv.lib;
    [ freetype pkgconfig ffmpeg libass docutils which ]
    ++ optionals x11Support [ libX11 libXext mesa ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional xineramaSupport libXinerama
    ++ optionals dvdnavSupport [ libdvdnav libdvdnav.libdvdread ]
    ++ optional bluraySupport libbluray
    ++ optional jackaudioSupport jackaudio
    ++ optional pulseSupport pulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
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
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
