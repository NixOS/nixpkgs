{ alsaSupport ? true, xvSupport ? true, theoraSupport ? true, cacaSupport ? true
, xineramaSupport ? true, randrSupport ? true, dvdnavSupport ? true
, stdenv, fetchurl, x11, freetype, fontconfig, zlib
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
, mesa, pkgconfig, unzip, yasm
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

stdenv.mkDerivation rec {
  name = "MPlayer-1.0-pre31984";

  src = fetchurl {
    url = "http://www.loegria.net/misc/${name}.tar.bz2";
    sha256 = "0mg6kggja113rsvvsk05gk50xl5qwzsms6pmb4ylc99mflh7m9km";
  };

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
    ++ stdenv.lib.optional lameSupport lame;

  buildNativeInputs = [ yasm ];

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    ${if x264Support then "--enable-x264 --extra-libs=-lx264" else ""}
    ${if codecs != null then "--codecsdir=${codecs}" else ""}
    ${if (stdenv.isi686 || stdenv.isx86_64) then "--enable-runtime-cpudetection" else ""}
    ${if x11Support then "--enable-x11" else ""}
    --disable-xanim
    --disable-ivtv
  '';

  NIX_LDFLAGS = if x11Support then "-lX11 -lXext" else "";

  crossAttrs = {
    preConfigure = ''
      configureFlags="`echo $configureFlags |
        sed -e 's/--build[^ ]\+//' \
        -e 's/--host[^ ]\+//' \
        -e 's/--codecsdir[^ ]\+//' \
        -e 's/--enable-runtime-cpudetection//' `"
      configureFlags="$configureFlags --target=${stdenv.cross.arch}-linux
        --cc=$crossConfig-gcc --as=$crossConfig-as"
    '';
  };

  meta = {
    description = "A movie player that supports many video formats";
    homepage = "http://mplayerhq.hu";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.urkud ];
  };
}
