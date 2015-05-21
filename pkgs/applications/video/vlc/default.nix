{ stdenv, fetchurl, xz, bzip2, perl, xlibs, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, fribidi, freefont_ttf, libebml, libmatroska
, libvorbis, libtheora, speex, lua5, libgcrypt, libupnp
, libcaca, pulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, udev, gnutls, avahi, libcddb, jack2, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi, libdc1394, libraw1394, libopus
, libvdpau
, onlyLibVLC ? false
, qt4 ? null, qt5 ? null, withQt5 ? false
}:

with stdenv.lib;

assert (withQt5 -> qt5 != null);
assert (!withQt5 -> qt4 != null);

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "http://download.videolan.org/vlc/${version}/${name}.tar.xz";
    sha256 = "1jqzrzrpw6932lbkf863xk8cfmn4z2ngbxz7w8ggmh4f6xz9sgal";
  };

  buildInputs =
    [ xz bzip2 perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
      libbluray dbus fribidi libvorbis libtheora speex lua5 libgcrypt
      libupnp libcaca pulseaudio flac schroedinger libxml2 librsvg mpeg2dec
      udev gnutls avahi libcddb jack2 SDL SDL_image libmtp unzip taglib
      libkate libtiger libv4l samba liboggz libass libdvbpsi libva
      xlibs.xlibs xlibs.libXv xlibs.libXvMC xlibs.libXpm xlibs.xcbutilkeysyms
      libdc1394 libraw1394 libopus libebml libmatroska libvdpau
    ] ++ (if withQt5 then with qt5; [ base ] else [qt4]);

  nativeBuildInputs = [ pkgconfig ];

  configureFlags =
    [ "--enable-alsa"
      "--with-kde-solid=$out/share/apps/solid/actions"
      "--enable-dc1394"
      "--enable-ncurses"
      "--enable-vdpau"
      "--enable-dvdnav"
    ]
    ++ optional onlyLibVLC  "--disable-vlc";

  preConfigure = ''sed -e "s@/bin/echo@echo@g" -i configure'';

  enableParallelBuilding = true;

  preBuild = ''
    substituteInPlace modules/text_renderer/freetype.c --replace \
      /usr/share/fonts/truetype/freefont/FreeSerifBold.ttf \
      ${freefont_ttf}/share/fonts/truetype/FreeSerifBold.ttf
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
