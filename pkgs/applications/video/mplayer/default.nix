{ config, lib, stdenv, fetchurl, fetchsvn, pkg-config, freetype, yasm, ffmpeg_4
, aalibSupport ? true, aalib
, fontconfigSupport ? true, fontconfig, freefont_ttf
, fribidiSupport ? true, fribidi
, x11Support ? true, libX11, libXext, libGLU, libGL
, xineramaSupport ? true, libXinerama
, xvSupport ? true, libXv
, alsaSupport ? stdenv.isLinux, alsa-lib
, screenSaverSupport ? true, libXScrnSaver
, vdpauSupport ? false, libvdpau
, cddaSupport ? !stdenv.isDarwin, cdparanoia
, dvdnavSupport ? !stdenv.isDarwin, libdvdnav
, dvdreadSupport ? true, libdvdread
, bluraySupport ? true, libbluray
, amrSupport ? false, amrnb, amrwb
, cacaSupport ? true, libcaca
, lameSupport ? true, lame
, speexSupport ? true, speex
, theoraSupport ? true, libtheora
, x264Support ? false, x264
, jackaudioSupport ? false, libjack2
, pulseSupport ? config.pulseaudio or false, libpulseaudio
, bs2bSupport ? false, libbs2b
, v4lSupport ? false, libv4l
# For screenshots
, libpngSupport ? true, libpng
, libjpegSupport ? true, libjpeg
, useUnfreeCodecs ? false
, darwin
, buildPackages
}:

assert xineramaSupport -> x11Support;
assert xvSupport -> x11Support;

let

  codecs_src =
    let
      dir = "http://www.mplayerhq.hu/MPlayer/releases/codecs/";
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

    meta.license = lib.licenses.unfree;
  } else null;

  crossBuild = stdenv.hostPlatform != stdenv.buildPlatform;

in

stdenv.mkDerivation rec {
  pname = "mplayer";
  version = "unstable-2022-02-03";

  src = fetchsvn {
    url = "svn://svn.mplayerhq.hu/mplayer/trunk";
    rev = "38331";
    sha256 = "1vpic8i6zvg0zsy50vhm45ysqag561bpn9jycfbvvwl9ji7l55zi";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure

    rm -rf ffmpeg
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config yasm ];
  buildInputs = with lib;
    [ freetype ffmpeg_4 ]
    ++ optional aalibSupport aalib
    ++ optional fontconfigSupport fontconfig
    ++ optional fribidiSupport fribidi
    ++ optionals x11Support [ libX11 libXext libGLU libGL ]
    ++ optional alsaSupport alsa-lib
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
    ++ optional v4lSupport libv4l
    ++ (with darwin.apple_sdk.frameworks; optionals stdenv.isDarwin [ Cocoa OpenGL ])
    ;

  configurePlatforms = [ ];
  configureFlags = with lib; [
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
    (if v4lSupport then "--enable-v4l2 --enable-tv-v4l2" else "--disable-v4l2 --disable-tv-v4l2")
    "--disable-xanim"
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
         (stdenv.hostPlatform.isx86 && !crossBuild)
         "--enable-runtime-cpudetection"
    ++ optional fribidiSupport "--enable-fribidi"
    ++ optional (stdenv.isLinux && !stdenv.isAarch64) "--enable-vidix"
    ++ optional stdenv.isLinux "--enable-fbdev"
    ++ optionals (crossBuild) [
    "--enable-cross-compile"
    "--disable-vidix-pcidb"
    "--with-vidix-drivers=no"
  ];

  preConfigure = ''
    configureFlagsArray+=(
      "--cc=$CC"
      "--host-cc=$CC_FOR_BUILD"
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

  NIX_LDFLAGS = with lib; toString (
       optional  fontconfigSupport "-lfontconfig"
    ++ optional  fribidiSupport "-lfribidi"
    ++ optionals x11Support [ "-lX11" "-lXext" ]
    ++ optional  x264Support "-lx264"
    ++ [ "-lfreetype" ]
  );

  installTargets = [ "install" ] ++ lib.optional x11Support "install-gui";

  enableParallelBuilding = true;

  # Provide a reasonable standard font when not using fontconfig. Maybe we should symlink here.
  postInstall = lib.optionalString (!fontconfigSupport)
    ''
      mkdir -p $out/share/mplayer
      cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
      if test -f $out/share/applications/mplayer.desktop ; then
        echo "NoDisplay=True" >> $out/share/applications/mplayer.desktop
      fi
    '';

  meta = with lib; {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ eelco ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
  };
}
