{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, faad2, ffmpeg, alsa
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
}:

stdenv.mkDerivation {
  name = "vlc-1.0.4";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/1.0.4/vlc-1.0.4.tar.bz2;
    sha256 = "15lqirz99dcghqdqsqlgb8fa2xs45a7r32zxhlzk5930rnh0pzyv";
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
