{ stdenv, fetchurl, autoreconfHook
, libarchive, perl, xorg, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, fribidi, freefont_ttf, libebml, libmatroska
, libvorbis, libtheora, speex, lua5, libgcrypt, libgpgerror, libupnp
, libcaca, libpulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, systemd, gnutls, avahi, libcddb, libjack2, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi, libdc1394, libraw1394, libopus
, libvdpau, libsamplerate, live555, fluidsynth, wayland, wayland-protocols
, onlyLibVLC ? false
, withQt5 ? true, qtbase ? null, qtsvg ? null, qtx11extras ? null
, jackSupport ? false
, fetchpatch
}:

with stdenv.lib;

assert (withQt5 -> qtbase != null && qtsvg != null && qtx11extras != null);

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "3.0.3";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${version}/${name}.tar.xz";
    sha256 = "0lavzly8l0ll1d9iris9cnirgcs77g48lxj14058dxqkvd5v1a4v";
  };

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
    libbluray dbus fribidi libvorbis libtheora speex lua5 libgcrypt libgpgerror
    libupnp libcaca libpulseaudio flac schroedinger libxml2 librsvg mpeg2dec
    systemd gnutls avahi libcddb SDL SDL_image libmtp unzip taglib libarchive
    libkate libtiger libv4l samba liboggz libass libdvbpsi libva
    xorg.xlibsWrapper xorg.libXv xorg.libXvMC xorg.libXpm xorg.xcbutilkeysyms
    libdc1394 libraw1394 libopus libebml libmatroska libvdpau libsamplerate live555
    fluidsynth wayland wayland-protocols
  ] ++ optionals withQt5    [ qtbase qtsvg qtx11extras ]
    ++ optional jackSupport libjack2;

  nativeBuildInputs = [ autoreconfHook perl pkgconfig ];

  enableParallelBuilding = true;

  LIVE555_PREFIX = live555;

  # vlc depends on a c11-gcc wrapper script which we don't have so we need to
  # set the path to the compiler
  BUILDCC = "${stdenv.cc}/bin/gcc";

  patches = [
    (fetchpatch {
      name = "vlc-qt5.11.patch";
      url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/vlc-qt5.11.patch?h=packages/vlc";
      sha256 = "0yh65bhhaz876cazhagnafs1dr61184lpj3y0m3y7k37bswykj8p";
    })
    (fetchpatch {
      url = "https://github.com/videolan/vlc/commit/26e2d3906658c30f2f88f4b1bc9630ec43bf5525.patch";
      sha256 = "0sm73cbzxva8sww526bh5yin1k2pdkvj826wdlmqnj7xf0f3mki4";
    })
  ];

  postPatch = ''
    substituteInPlace configure \
      --replace /bin/echo echo

    substituteInPlace modules/text_renderer/freetype/platform_fonts.h --replace \
      /usr/share/fonts/truetype/freefont ${freefont_ttf}/share/fonts/truetype
  '';

  # https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  postFixup = ''
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    $out/lib/vlc/vlc-cache-gen $out/vlc/plugins
  '';

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--with-kde-solid=$out/share/apps/solid/actions"
  ] ++ optional onlyLibVLC "--disable-vlc";

  meta = with stdenv.lib; {
    description = "Cross-platform media player and streaming server";
    homepage = http://www.videolan.org/vlc/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
