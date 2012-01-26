{ stdenv, fetchurl, perl, xlibs, libdvdnav
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
  version = "1.1.13";

  patchPhase = ''sed -e "s@/bin/echo@echo@g" -i configure'';

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/vlc/${version}/${name}.tar.bz2";
    sha256 = "1h93jdx89dfgxlnw66lfcdk9kisadm689zanvgkzbfb3si2frv83";
  };

  buildInputs = [
    perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
    dbus fribidi qt4 libvorbis libtheora speex lua5 libgcrypt
    libupnp libcaca pulseaudio flac schroedinger libxml2 librsvg mpeg2dec
    udev gnutls avahi libcddb jackaudio SDL SDL_image libmtp unzip taglib
    libkate libtiger libv4l samba liboggz libass libdvbpsi
  ]
  ++ (with xlibs; [ xlibs.xlibs libXv libXvMC libXpm xcbutil libva ]);

  buildNativeInputs = [ pkgconfig ];

  configureFlags = [ "--enable-alsa"
    "--with-kde-solid=$out/share/apps/solid/actions"
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
