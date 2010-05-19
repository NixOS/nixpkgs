{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, faad2, ffmpeg, alsa
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
, libvorbis, libtheora, speex
}:

stdenv.mkDerivation {
  name = "vlc-1.0.6";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/1.0.6/vlc-1.0.6.tar.bz2;
    sha256 = "0hhqbr0hwm07pimdy4rfmf3k3d6iz6icmrndirnp888hg8z968gm";
  };

  buildInputs = [
    perl xlibs.xlibs xlibs.libXv zlib a52dec libmad faad2 ffmpeg
    alsa libdvdnav libdvdnav.libdvdread pkgconfig dbus hal fribidi qt4
    libvorbis libtheora speex
  ];

  configureFlags = "--enable-alsa --disable-glx --disable-remoteosd --enable-faad --enable-theora --enable-vorbis --enable-speex";

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
