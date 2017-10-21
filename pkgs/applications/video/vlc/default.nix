{ stdenv, fetchurl, xz, bzip2, perl, xorg, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg, alsaLib
, pkgconfig, dbus, fribidi, freefont_ttf, libebml, libmatroska
, libvorbis, libtheora, speex, lua5, libgcrypt, libupnp
, libcaca, libpulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, udev, gnutls, avahi, libcddb, libjack2, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, liboggz
, libass, libva, libdvbpsi, libdc1394, libraw1394, libopus
, libvdpau, libsamplerate, live555, fluidsynth
, onlyLibVLC ? false
, qt4 ? null
, withQt5 ? false, qtbase ? null, qtx11extras ? null
, jackSupport ? false
, fetchpatch
}:

with stdenv.lib;

assert (withQt5 -> qtbase != null && qtx11extras != null);
assert (!withQt5 -> qt4 != null);

stdenv.mkDerivation rec {
  name = "vlc-${version}";
  version = "2.2.6";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${version}/${name}.tar.xz";
    sha256 = "1a22b913p2227ljz89c4fgjlyln5gcz8z58w32r0wh4srnnd60y4";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-9300.patch";
      url = "https://git.videolan.org/?p=vlc/vlc-2.2.git;a=patch;h=55a82442cfea9dab8b853f3a4610f2880c5fadf3;hp=dbe888f9ca9c3b102478b4a16a3d1d985c267899";
      sha256 = "0l0fwqkn31lggwc5dkhb58gkv8pc6ng51y0izjigqvfqvhwdnzxn";
    })
  ];

  # Comment-out the Qt 5.5 version check, as we do apply the relevant patch.
  # https://trac.videolan.org/vlc/ticket/16497
  postPatch = if (!withQt5) then null else
    "sed '/I78ef29975181ee22429c9bd4b11d96d9e68b7a9c/s/^/: #/' -i configure";

  buildInputs =
    [ xz bzip2 perl zlib a52dec libmad faad2 ffmpeg alsaLib libdvdnav libdvdnav.libdvdread
      libbluray dbus fribidi libvorbis libtheora speex lua5 libgcrypt
      libupnp libcaca libpulseaudio flac schroedinger libxml2 librsvg mpeg2dec
      udev gnutls avahi libcddb SDL SDL_image libmtp unzip taglib
      libkate libtiger libv4l samba liboggz libass libdvbpsi libva
      xorg.xlibsWrapper xorg.libXv xorg.libXvMC xorg.libXpm xorg.xcbutilkeysyms
      libdc1394 libraw1394 libopus libebml libmatroska libvdpau libsamplerate live555
      fluidsynth
    ]
    ++ [(if withQt5 then qtbase else qt4)]
    ++ optional withQt5 qtx11extras
    ++ optional jackSupport libjack2;

  nativeBuildInputs = [ pkgconfig ];

  LIVE555_PREFIX = live555;

  preConfigure = ''
    sed -e "s@/bin/echo@echo@g" -i configure
  '' + optionalString withQt5 ''
    # Make sure we only *add* "-std=c++11" to CXXFLAGS instead of overriding the
    # values figured out by configure (for example "-g -O2").
    sed -i -re '/^ *CXXFLAGS=("[^$"]+")? *$/s/CXXFLAGS="?/&-std=c++11 /' \
      configure
  '';

  configureFlags =
    [ "--enable-alsa"
      "--with-kde-solid=$out/share/apps/solid/actions"
      "--enable-dc1394"
      "--enable-ncurses"
      "--enable-vdpau"
      "--enable-dvdnav"
      "--enable-samplerate"
    ]
    ++ optional onlyLibVLC  "--disable-vlc";

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
