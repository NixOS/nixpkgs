{ config, stdenv, fetchurl, pkgconfig, freetype, yasm, ffmpeg
, aalibSupport ? true, aalib ? null
, fontconfigSupport ? true, fontconfig ? null, freefont_ttf ? null
, fribidiSupport ? true, fribidi ? null
, x11Support ? true, libX11 ? null, libXext ? null, libGLU, libGL ? null
, xineramaSupport ? true, libXinerama ? null
, xvSupport ? true, libXv ? null
, alsaSupport ? stdenv.isLinux, alsaLib ? null
, screenSaverSupport ? true, libXScrnSaver ? null
, vdpauSupport ? false, libvdpau ? null
, cddaSupport ? !stdenv.isDarwin, cdparanoia ? null
, dvdnavSupport ? !stdenv.isDarwin, libdvdnav ? null
, dvdreadSupport ? true, libdvdread ? null
, bluraySupport ? true, libbluray ? null
, amrSupport ? false, amrnb ? null, amrwb ? null
, cacaSupport ? true, libcaca ? null
, lameSupport ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, x264Support ? false, x264 ? null
, jackaudioSupport ? false, libjack2 ? null
, pulseSupport ? config.pulseaudio or false, libpulseaudio ? null
, bs2bSupport ? false, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
, libjpegSupport ? true, libjpeg ? null
, useUnfreeCodecs ? false
, darwin ? null
, buildPackages
}:

assert fontconfigSupport -> (fontconfig != null);
assert (!fontconfigSupport) -> (freefont_ttf != null);
assert fribidiSupport -> (fribidi != null);
assert x11Support -> (libX11 != null && libXext != null && libGLU != null && libGL != null);
assert xineramaSupport -> (libXinerama != null && x11Support);
assert xvSupport -> (libXv != null && x11Support);
assert alsaSupport -> alsaLib != null;
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;
assert cddaSupport -> cdparanoia != null;
assert dvdnavSupport -> libdvdnav != null;
assert dvdreadSupport -> libdvdread != null;
assert bluraySupport -> libbluray != null;
assert amrSupport -> (amrnb != null && amrwb != null);
assert cacaSupport -> libcaca != null;
assert lameSupport -> lame != null;
assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert x264Support -> x264 != null;
assert jackaudioSupport -> libjack2 != null;
assert pulseSupport -> libpulseaudio != null;
assert bs2bSupport -> libbs2b != null;
assert libpngSupport -> libpng != null;
assert libjpegSupport -> libjpeg != null;

let

  codecs_src =
    let
      dir = http://www.mplayerhq.hu/MPlayer/releases/codecs/;
      version = "20071007";
    in
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      url = "${dir}/essential-${version}.tar.bz2";
      sha256 = "18vls12n12rjw0mzw4pkp9vpcfmd1c21rzha19d7zil4hn7fs2ic";
    } else if stdenv.hostPlatform.system == "x86_64-linux" then fetchurl {
      url = "${dir}/essential-amd64-${version}.tar.bz2";
      sha256 = "13xf5b92w1ra5hw00ck151lypbmnylrnznq9hhb0sj36z5wz290x";
    } else if stdenv.hostPlatform.system == "powerpc-linux" then fetchurl {
      url = "${dir}/essential-ppc-${version}.tar.bz2";
      sha256 = "18mlj8dp4wnz42xbhdk1jlz2ygra6fbln9wyrcyvynxh96g1871z";
    } else null;

  codecs = if codecs_src != null then stdenv.mkDerivation {
    pname = "MPlayer-codecs-essential";

    src = codecs_src;

    installPhase = ''
      mkdir $out
      cp -prv * $out
    '';

    meta.license = stdenv.lib.licenses.unfree;
  } else null;

  crossBuild = stdenv.hostPlatform != stdenv.buildPlatform;

in

stdenv.mkDerivation rec {
  pname = "mplayer";
  version = "1.4";

  src = fetchurl {
    url = "http://www.mplayerhq.hu/MPlayer/releases/MPlayer-${version}.tar.xz";
    sha256 = "0j5mflr0wnklxsvnpmxvk704hscyn2785hvvihj2i3a7b3anwnc2";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure

    rm -rf ffmpeg
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgconfig yasm ];
  buildInputs = with stdenv.lib;
    [ freetype ffmpeg ]
    ++ optional aalibSupport aalib
    ++ optional fontconfigSupport fontconfig
    ++ optional fribidiSupport fribidi
    ++ optionals x11Support [ libX11 libXext libGLU libGL ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional cacaSupport libcaca
    ++ optional xineramaSupport libXinerama
    ++ optional dvdnavSupport libdvdnav
    ++ optional dvdreadSupport libdvdread
    ++ optional bluraySupport libbluray
    ++ optional cddaSupport cdparanoia
    ++ optional jackaudioSupport libjack2
    ++ optionals amrSupport [ amrnb amrwb ]
    ++ optional x264Support x264
    ++ optional pulseSupport libpulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional lameSupport lame
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
    ++ optional libpngSupport libpng
    ++ optional libjpegSupport libjpeg
    ++ optional bs2bSupport libbs2b
    ++ (with darwin.apple_sdk.frameworks; optionals stdenv.isDarwin [ Cocoa OpenGL ])
    ;

  configurePlatforms = [ ];
  configureFlags = with stdenv.lib; [
    "--enable-freetype"
    (if fontconfigSupport then "--enable-fontconfig" else "--disable-fontconfig")
    (if x11Support then "--enable-x11 --enable-gl" else "--disable-x11 --disable-gl")
    (if xineramaSupport then "--enable-xinerama" else "--disable-xinerama")
    (if xvSupport then "--enable-xv" else "--disable-xv")
    (if alsaSupport then "--enable-alsa" else "--disable-alsa")
    (if screenSaverSupport then "--enable-xss" else "--disable-xss")
    (if vdpauSupport then "--enable-vdpau" else "--disable-vdpau")
    (if cddaSupport then "--enable-cdparanoia" else "--disable-cdparanoia")
    (if dvdnavSupport then "--enable-dvdnav" else "--disable-dvdnav")
    (if bluraySupport then "--enable-bluray" else "--disable-bluray")
    (if amrSupport then "--enable-libopencore_amrnb" else "--disable-libopencore_amrnb")
    (if cacaSupport then "--enable-caca" else "--disable-caca")
    (if lameSupport then "--enable-mp3lame --disable-mp3lame-lavc" else "--disable-mp3lame --enable-mp3lame-lavc")
    (if speexSupport then "--enable-speex" else "--disable-speex")
    (if theoraSupport then "--enable-theora" else "--disable-theora")
    (if x264Support then "--enable-x264 --disable-x264-lavc" else "--disable-x264 --enable-x264-lavc")
    (if jackaudioSupport then "" else "--disable-jack")
    (if pulseSupport then "--enable-pulse" else "--disable-pulse")
    "--disable-xanim"
    "--disable-ivtv"
    "--disable-xvid --disable-xvid-lavc"
    "--disable-ossaudio"
    "--disable-ffmpeg_a"
    "--yasm=${buildPackages.yasm}/bin/yasm"
    # Note, the `target` vs `host` confusion is intensional.
    "--target=${stdenv.hostPlatform.config}"
  ] ++ optional
         (useUnfreeCodecs && codecs != null && !crossBuild)
         "--codecsdir=${codecs}"
    ++ optional
         ((stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) && !crossBuild)
         "--enable-runtime-cpudetection"
    ++ optional fribidiSupport "--enable-fribidi"
    ++ optional stdenv.isLinux "--enable-vidix"
    ++ optional stdenv.isLinux "--enable-fbdev"
    ++ optionals (crossBuild) [
    "--enable-cross-compile"
    "--disable-vidix-pcidb"
    "--with-vidix-drivers=no"
  ];

  preConfigure = ''
    configureFlagsArray+=(
      "--cc=$CC"
      "--host-cc=$BUILD_CC"
      "--as=$AS"
      "--nm=$NM"
      "--ar=$AR"
      "--ranlib=$RANLIB"
      "--windres=$WINDRES"
    )
  '';

  postConfigure = ''
    echo CONFIG_MPEGAUDIODSP=yes >> config.mak
  '';

  NIX_LDFLAGS = with stdenv.lib; toString (
       optional  fontconfigSupport "-lfontconfig"
    ++ optional  fribidiSupport "-lfribidi"
    ++ optionals x11Support [ "-lX11" "-lXext" ]
  );

  installTargets = [ "install" ] ++ stdenv.lib.optional x11Support "install-gui";

  enableParallelBuilding = true;

  # Provide a reasonable standard font when not using fontconfig. Maybe we should symlink here.
  postInstall = stdenv.lib.optionalString (!fontconfigSupport)
    ''
      mkdir -p $out/share/mplayer
      cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
      if test -f $out/share/applications/mplayer.desktop ; then
        echo "NoDisplay=True" >> $out/share/applications/mplayer.desktop
      fi
    '';

  meta = {
    description = "A movie player that supports many video formats";
    homepage = http://mplayerhq.hu;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
