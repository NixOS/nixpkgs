{ stdenv, fetchurl, xz, bzip2, perl, xlibs, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, fribidi, qt4, freefont_ttf
, libvorbis, libtheora, speex, lua5, libgcrypt, libupnp
, libcaca, pulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, udev, gnutls, avahi, libcddb, jackaudio, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi
}:

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/vlc/${version}/${name}.tar.xz";
    sha256 = "7f485725c17487a77d70844cbd9acf528360d65cd6ff79d206657920f4fcbf4b";
  };

  buildInputs =
    [ xz bzip2 perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
      libbluray dbus fribidi qt4 libvorbis libtheora speex lua5 libgcrypt
      libupnp libcaca pulseaudio flac schroedinger libxml2 librsvg mpeg2dec
      udev gnutls avahi libcddb jackaudio SDL SDL_image libmtp unzip taglib
      libkate libtiger libv4l samba liboggz libass libdvbpsi libva
      xlibs.xlibs xlibs.libXv xlibs.libXvMC xlibs.libXpm xlibs.xcbutilkeysyms
    ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags =
    [ "--enable-alsa"
      "--with-kde-solid=$out/share/apps/solid/actions"
    ];

  preConfigure = ''sed -e "s@/bin/echo@echo@g" -i configure'';

  enableParallelBuilding = true;

  preBuild = ''
    substituteInPlace modules/text_renderer/freetype.c --replace \
      /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf \
      ${freefont_ttf}/share/fonts/truetype/FreeSerifBold.ttf
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
  };
}
