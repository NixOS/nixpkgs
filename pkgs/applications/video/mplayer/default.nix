{ stdenv, fetchurl, pkgconfig, freetype, yasm
, fontconfigSupport ? true, fontconfig ? null, freefont_ttf ? null
, x11Support ? true, libX11 ? null, libXext ? null, mesa ? null
, xineramaSupport ? true, libXinerama ? null
, xvSupport ? true, libXv ? null
, alsaSupport ? true, alsaLib ? null
, screenSaverSupport ? true, libXScrnSaver ? null
, vdpauSupport ? false, libvdpau ? null
, cddaSupport ? true, cdparanoia ? null
, dvdnavSupport ? true, libdvdnav ? null
, bluraySupport ? true, libbluray ? null
, amrSupport ? false, amrnb ? null, amrwb ? null
, cacaSupport ? true, libcaca ? null
, lameSupport ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, x264Support ? false, x264 ? null
, jackaudioSupport ? false, jackaudio ? null
, pulseSupport ? false, pulseaudio ? null
, bs2bSupport ? false, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
, useUnfreeCodecs ? false
}:

assert fontconfigSupport -> (fontconfig != null);
assert (!fontconfigSupport) -> (freefont_ttf != null);
assert x11Support -> (libX11 != null && libXext != null && mesa != null);
assert xineramaSupport -> (libXinerama != null && x11Support);
assert xvSupport -> (libXv != null && x11Support);
assert alsaSupport -> alsaLib != null;
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;
assert cddaSupport -> cdparanoia != null;
assert dvdnavSupport -> libdvdnav != null;
assert bluraySupport -> libbluray != null;
assert amrSupport -> (amrnb != null && amrwb != null);
assert cacaSupport -> libcaca != null;
assert lameSupport -> lame != null;
assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert x264Support -> x264 != null;
assert jackaudioSupport -> jackaudio != null;
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

    meta.license = "unfree";
  } else null;

in

stdenv.mkDerivation rec {
  name = "mplayer-1.1";

  src = fetchurl {
    # Old kind of URL:
    # url = http://tarballs.nixos.org/mplayer-snapshot-20101227.tar.bz2;
    # Snapshot I took on 20110423

    #Transient
    #url = http://www.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2;
    #sha256 = "cc1b3fda75b172f02c3f46581cfb2c17f4090997fe9314ad046e464a76b858bb";

    url = "http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.tar.xz";
    sha256 = "173cmsfz7ckzy1hay9mpnc5as51127cfnxl20b521d2jvgm4gjvn";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure
  '';

  buildInputs = with stdenv.lib;
    [ pkgconfig freetype ]
    ++ optional fontconfigSupport fontconfig
    ++ optionals x11Support [ libX11 libXext mesa ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional cacaSupport libcaca
    ++ optional xineramaSupport libXinerama
    ++ optional dvdnavSupport libdvdnav
    ++ optional bluraySupport libbluray
    ++ optional cddaSupport cdparanoia
    ++ optional jackaudioSupport jackaudio
    ++ optionals amrSupport [ amrnb amrwb ]
    ++ optional x264Support x264
    ++ optional pulseSupport pulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional lameSupport lame
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
    ++ optional libpngSupport libpng
    ++ optional bs2bSupport libbs2b
    ;

  nativeBuildInputs = [ yasm ];

  postConfigure = ''
    echo CONFIG_MPEGAUDIODSP=yes >> config.mak
  '';

  configureFlags = with stdenv.lib;
    ''
      --enable-freetype
      ${if fontconfigSupport then "--enable-fontconfig" else "--disable-fontconfig"}
      ${if x11Support then "--enable-x11 --enable-gl" else "--disable-x11 --disable-gl"}
      ${if xineramaSupport then "--enable-xinerama" else "--disable-xinerama"}
      ${if xvSupport then "--enable-xv" else "--disable-xv"}
      ${if alsaSupport then "--enable-alsa" else "--disable-alsa"}
      ${if screenSaverSupport then "--enable-xss" else "--disable-xss"}
      ${if vdpauSupport then "--enable-vdpau" else "--disable-vdpau"}
      ${if cddaSupport then "--enable-cdparanoia" else "--disable-cdparanoia"}
      ${if dvdnavSupport then "--enable-dvdnav" else "--disable-dvdnav"}
      ${if bluraySupport then "--enable-bluray" else "--disable-bluray"}
      ${if amrSupport then "--enable-libopencore_amrnb" else "--disable-libopencore_amrnb"}
      ${if cacaSupport then "--enable-caca" else "--disable-caca"}
      ${if lameSupport then "--enable-mp3lame --disable-mp3lame-lavc" else "--disable-mp3lame --enable-mp3lame-lavc"}
      ${if speexSupport then "--enable-speex" else "--disable-speex"}
      ${if theoraSupport then "--enable-theora" else "--disable-theora"}
      ${if x264Support then "--enable-x264 --disable-x264-lavc" else "--disable-x264 --enable-x264-lavc"}
      ${if jackaudioSupport then "--enable-jack" else "--disable-jack"}
      ${if pulseSupport then "--enable-pulse" else "--disable-pulse"}
      ${optionalString (useUnfreeCodecs && codecs != null) "--codecsdir=${codecs}"}
      ${optionalString (stdenv.isi686 || stdenv.isx86_64) "--enable-runtime-cpudetection"}
      --disable-xanim
      --disable-ivtv
      --disable-xvid --disable-xvid-lavc
      --enable-vidix
      --enable-fbdev
      --disable-ossaudio
    '';

  NIX_LDFLAGS = with stdenv.lib;
       optional  fontconfigSupport "-lfontconfig"
    ++ optionals x11Support [ "-lX11" "-lXext" ]
    ;

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

  crossAttrs = {
    dontSetConfigureCross = true;
    # Some things (vidix) are nanonote specific. Once someone cares, we can make options from them.
    preConfigure = ''
      configureFlags="`echo $configureFlags |
        sed -e 's/--codecsdir[^ ]\+//' \
        -e 's/--enable-runtime-cpudetection//' `"
      configureFlags="$configureFlags --target=${stdenv.cross.arch}-linux
        --enable-cross-compile --cc=$crossConfig-gcc --as=$crossConfig-as
        --disable-vidix-pcidb --with-vidix-drivers=no --host-cc=gcc"
    '';
  };

  meta = {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
