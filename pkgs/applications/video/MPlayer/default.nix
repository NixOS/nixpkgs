{ alsaSupport ? true, xvSupport ? true, theoraSupport ? true, cacaSupport ? true
, xineramaSupport ? true, randrSupport ? true, dvdnavSupport ? true
, stdenv, fetchurl, fetchsvn, fetchgit, x11, freetype, fontconfig, zlib
, alsaLib ? null, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null, libdvdnav ? null
, cdparanoia ? null, cddaSupport ? true
, amrnb ? null, amrwb ? null, amrSupport ? false
, x11Support ? true, libX11 ? null, libXext ? null
, jackaudioSupport ? false, jackaudio ? null
, x264Support ? false, x264 ? null
, xvidSupport ? false, xvidcore ? null
, lameSupport ? true, lame ? null
, screenSaverSupport ? true, libXScrnSaver
, pulseSupport ? false, pulseaudio
, mesa, pkgconfig, unzip, yasm, freefont_ttf
, vdpauSupport ? false, libvdpau ? null
}:

assert alsaSupport -> alsaLib != null;
assert x11Support -> libX11 != null;
assert xvSupport -> (libXv != null && x11Support);
assert theoraSupport -> libtheora != null;
assert cacaSupport -> libcaca != null;
assert xineramaSupport -> (libXinerama != null && x11Support);
assert randrSupport -> (libXrandr != null && x11Support);
assert dvdnavSupport -> libdvdnav != null;
assert cddaSupport -> cdparanoia != null;
assert jackaudioSupport -> jackaudio != null;
assert amrSupport -> (amrnb != null && amrwb != null);
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;

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

    meta = {
      license = "unfree";
    };
  } else null;

  ffmpegGit = fetchgit {
    url = "git://git.videolan.org/ffmpeg.git";
    rev = "9e53f62be1a171eaf9620958c225d42cf5142a30";
    sha256 = "be0ef2a394c82a0eee0be66bc0b943d37efb90f74ce1030aa89606109434c943";
  };

  mplayerRev = "34586";

in

stdenv.mkDerivation rec {
  name = "mplayer-${mplayerRev}";

  src = fetchsvn {
    # Old kind of URL:
    # url = http://nixos.org/tarballs/mplayer-snapshot-20101227.tar.bz2;
    # Snapshot I took on 20110423

    #Transient
    #url = http://www.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2;
    #sha256 = "cc1b3fda75b172f02c3f46581cfb2c17f4090997fe9314ad046e464a76b858bb";

    url = "svn://svn.mplayerhq.hu/mplayer/trunk";
    rev = "${mplayerRev}";
    sha256 = "5688add3256b5de8e0410194232aaaeb01531bb507459ffe4f07e69cb2d81bd7";
  };

  prePatch = ''
    sed -i /^_install_strip/d configure
  '';

  buildInputs =
    [ freetype zlib pkgconfig ]
    ++ stdenv.lib.optional x11Support [ libX11 libXext mesa ]
    ++ stdenv.lib.optional alsaSupport alsaLib
    ++ stdenv.lib.optional xvSupport libXv
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional cacaSupport libcaca
    ++ stdenv.lib.optional xineramaSupport libXinerama
    ++ stdenv.lib.optional randrSupport libXrandr
    ++ stdenv.lib.optionals dvdnavSupport [ libdvdnav libdvdnav.libdvdread ]
    ++ stdenv.lib.optional cddaSupport cdparanoia
    ++ stdenv.lib.optional jackaudioSupport jackaudio
    ++ stdenv.lib.optionals amrSupport [ amrnb amrwb ]
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional pulseSupport pulseaudio
    ++ stdenv.lib.optional screenSaverSupport libXScrnSaver
    ++ stdenv.lib.optional lameSupport lame
    ++ stdenv.lib.optional vdpauSupport libvdpau;

  buildNativeInputs = [ yasm ];

  preConfigure = ''
    cp -r ${ffmpegGit} ffmpeg
    chmod u+w -R ffmpeg
    sed -ie '1i#include "libavutil/intreadwrite.h"' ffmpeg/libavcodec/libmp3lame.c
  '';

  postConfigure = ''
    echo CONFIG_MPEGAUDIODSP=yes >> config.mak
  '';

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    ${if x264Support then "--enable-x264 --extra-libs=-lx264" else ""}
    ${if codecs != null then "--codecsdir=${codecs}" else ""}
    ${if (stdenv.isi686 || stdenv.isx86_64) then "--enable-runtime-cpudetection" else ""}
    ${if x11Support then "--enable-x11" else ""}
    --disable-xanim
    --disable-ivtv
    --enable-vidix
    --enable-fbdev
    --disable-ossaudio
  '';

  NIX_LDFLAGS = if x11Support then "-lX11 -lXext" else "";

  # Provide a reasonable standard font.  Maybe we should symlink here.
  postInstall =
    ''
      mkdir -p $out/share/mplayer
      cp ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mplayer/subfont.ttf
    '';

  crossAttrs = {
    dontSetConfigureCross = true;
    # Some things (vidix) are nanonote specific. Once someone cares, we can make options from them.
    preConfigure = preConfigure + ''
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
