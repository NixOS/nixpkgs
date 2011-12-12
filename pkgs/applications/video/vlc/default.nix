{ stdenv, fetchurl, perl, xlibs, libdvdnav
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, hal, fribidi, qt4, freefont_ttf
, libvorbis, libtheora, speex, lua, libgcrypt, libupnp
, libcaca, pulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, udev, gnutls, avahi, libcddb, jackaudio, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi
}:

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "1.1.11";

  patchPhase = ''sed -e "s@/bin/echo@echo@g" -i configure'';

  src = fetchurl {
    url = "mirror://sourceforge/vlc/${name}.tar.bz2";
    sha256 = "1jz1yklvh5apy2ygqwnyq61mhg09h0fn32hdygxfsaxq12z609b8";
  };

  buildInputs = [
    perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
    pkgconfig dbus hal fribidi qt4 libvorbis libtheora speex lua libgcrypt
    libupnp libcaca pulseaudio flac schroedinger libxml2 librsvg mpeg2dec
    udev gnutls avahi libcddb jackaudio SDL SDL_image libmtp unzip taglib
    libkate libtiger libv4l samba liboggz libass libdvbpsi
  ]
  ++ (with xlibs; [ xlibs.xlibs libXv libXvMC libXpm xcbutil libva ]);

  configureFlags = [ "--enable-alsa"
    "--disable-glx"
    "--disable-remoteosd"
    "--disable-dbus"
    "--disable-dbus-control"
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
