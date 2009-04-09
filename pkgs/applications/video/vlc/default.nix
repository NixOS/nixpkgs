{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, faad2, ffmpeg, alsa
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
}:

stdenv.mkDerivation {
  name = "vlc-0.9.9";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.9.9/vlc-0.9.9.tar.bz2;
    sha256 = "0jg9sgwzz1p9mwnzrnfg9gpkcjd549gnkw0zjp9v2q2cclg2jknh";
  };

  buildInputs = [
    perl xlibs.xlibs xlibs.libXv zlib a52dec libmad faad2 ffmpeg
    alsa libdvdnav libdvdnav.libdvdread pkgconfig dbus hal fribidi qt4
  ];

  configureFlags = "--enable-alsa --disable-glx --disable-remoteosd --enable-faad";

  preBuild = ''
    substituteInPlace modules/misc/freetype.c --replace \
      /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf \
      ${freefont_ttf}/share/fonts/truetype/FreeSerifBold.ttf
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
  };
}
