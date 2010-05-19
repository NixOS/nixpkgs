{ alsaSupport ? false, xvSupport ? true, theoraSupport ? false, cacaSupport ? false
, xineramaSupport ? false, randrSupport ? false, dvdnavSupport ? true
, stdenv, fetchurl, x11, freetype, fontconfig, zlib
, alsa ? null, libX11, libXv ? null, libtheora ? null, libcaca ? null
, libXinerama ? null, libXrandr ? null, libdvdnav ? null
, cdparanoia ? null, cddaSupport ? true
, amrnb ? null, amrwb ? null, amrSupport ? false
, jackaudioSupport ? false, jackaudio ? null
, x264Support ? false, x264 ? null
, xvidSupport ? false, xvidcore ? null
, mesa, pkgconfig, unzip
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
assert amrSupport -> (amrnb != null && amrwb != null);

let

  codecs = stdenv.mkDerivation {
    name = "MPlayer-codecs-essential-20071007";
  
    src = fetchurl {
      url = http://www2.mplayerhq.hu/MPlayer/releases/codecs/essential-20071007.tar.bz2;
      sha256 = "18vls12n12rjw0mzw4pkp9vpcfmd1c21rzha19d7zil4hn7fs2ic";
    };

    installPhase = ''
      mkdir $out
      cp -prv * $out
    '';
  
    meta = {
      license = "unfree";
    };
  };

in  

stdenv.mkDerivation {
  name = "MPlayer-1.0-pre-rc4-20100506";

  src = fetchurl {
    url = mirror://gentoo/distfiles/mplayer-1.0_rc4_p20100506.tar.bz2;
    sha256 = "0rhs0mv216iir8cz13xdq0rs88lc48ciiyn0wqzxjrnjb17yajy6";
  };

  buildInputs =
    [ x11 libXv freetype zlib mesa pkgconfig ]
    ++ stdenv.lib.optional alsaSupport alsa
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
    ++ stdenv.lib.optional xvidSupport xvidcore;

  configureFlags = ''
    ${if cacaSupport then "--enable-caca" else "--disable-caca"}
    ${if dvdnavSupport then "--enable-dvdnav --enable-dvdread --disable-dvdread-internal" else ""}
    ${if x264Support then "--enable-x264 --extra-libs=-lx264" else ""}
    --codecsdir=${codecs}
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
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
