{ alsaSupport ? true, xvSupport ? true, theoraSupport ? true, cacaSupport ? true
, xineramaSupport ? true, randrSupport ? true, dvdnavSupport ? true
, stdenv, fetchurl, fetchsvn, x11, freetype, fontconfig, zlib
, alsaLib, libX11, libXv, libtheora, libcaca
, libXinerama, libXrandr, libdvdnav
, cdparanoia, cddaSupport ? true
, pulseaudio, pulseSupport ? true
, amrnb, amrwb, amrSupport ? false
, jackaudioSupport ? false, jackaudio
, x264Support ? true, x264
, xvidSupport ? true, xvidcore
, lameSupport ? true, lame
, screenSaverSupport ? true, libXScrnSaver
, mesa, pkgconfig, unzip, yasm
}:

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

in  

stdenv.mkDerivation {
  name = "MPlayer-1.0-pre-rc4-20100506";

  src = fetchsvn {
    url = svn://svn.mplayerhq.hu/mplayer/trunk;
    rev = 31984;
    sha256 = "01niw0c7fwbp4v25k08c2rac8z55jp2wh5ikhsjn65ybg8f1v150";
  };

  buildInputs =
    [ x11 libXv freetype zlib mesa pkgconfig yasm ]
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
    ++ stdenv.lib.optional lameSupport lame;

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    ${if x264Support then "--enable-x264 --extra-libs=-lx264" else ""}
    ${if codecs != null then "--codecsdir=${codecs}" else ""}
    --enable-runtime-cpudetection
    --enable-x11
    --disable-xanim
    --disable-ivtv
  '';

  NIX_LDFLAGS = "-lX11 -lXext";

  meta = {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.urkud ];
  };
}
