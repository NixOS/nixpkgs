{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, faad2, ffmpeg, alsa
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
, libvorbis, libtheora, speex, lua, libgcrypt
}:

stdenv.mkDerivation {
  name = "vlc-1.1.0";

  src = fetchurl {
    url = http://download.videolan.org/pub/videolan/vlc/1.1.0/vlc-1.1.0.tar.bz2;
    sha256 = "1j7icg7a2lr99kpc3sjjdp3z7128y6afnvxsafxlnih0qif2ryx9";
  };

  buildInputs = [
    perl xlibs.xlibs xlibs.libXv zlib a52dec libmad faad2 ffmpeg
    alsa libdvdnav libdvdnav.libdvdread pkgconfig dbus hal fribidi qt4
    libvorbis libtheora speex lua libgcrypt
  ];

  configureFlags = [ "--enable-alsa"
    "--disable-glx"
    "--disable-remoteosd"
    "--enable-faad"
    "--enable-theora"
    "--enable-vorbis"
    "--enable-speex"
    "--disable-dbus"
    "--disable-dbus-control"
  ];

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
