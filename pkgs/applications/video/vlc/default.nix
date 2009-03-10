{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, ffmpeg, alsa
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
}:

stdenv.mkDerivation {
  name = "vlc-0.9.8a";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/0.9.8a/vlc-0.9.8a.tar.bz2;
    sha256 = "0kw2d7yh8rzb61j1q2cvnjinj1wxc9a7smxl7ckw1vwh6y02jz0r";
  };

  buildInputs = [
    perl xlibs.xlibs xlibs.libXv zlib a52dec libmad ffmpeg alsa
    libdvdnav libdvdnav.libdvdread
    pkgconfig dbus hal fribidi qt4
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
