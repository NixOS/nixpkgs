{ lib
, stdenv
, fetchurl
, fetchpatch
, SDL
, SDL_image
, a52dec
, alsa-lib
, autoreconfHook
, avahi
, dbus
, faad2
, ffmpeg
, flac
, fluidsynth
, freefont_ttf
, fribidi
, gnutls
, libarchive
, libass
, libbluray
, libcaca
, libcddb
, libdc1394
, libdvbpsi
, libdvdnav
, libebml
, libgcrypt
, libgpg-error
, libjack2
, libkate
, libmad
, libmatroska
, libmtp
, liboggz
, libopus
, libpulseaudio
, libraw1394
, librsvg
, libsamplerate
, libspatialaudio
, libssh2
, libtheora
, libtiger
, libupnp
, libv4l
, libva
, libvdpau
, libvorbis
, libxml2
, live555
, lua5
, mpeg2dec
, ncurses
, perl
, pkg-config
, removeReferencesTo
, samba
, schroedinger
, speex
, srt
, systemd
, taglib
, unzip
, xorg
, zlib
, chromecastSupport ? true, libmicrodns, protobuf
, jackSupport ? false
, onlyLibVLC ? false
, skins2Support ? !onlyLibVLC, freetype
, waylandSupport ? true, wayland, wayland-protocols
, withQt5 ? true, qtbase, qtsvg, qtwayland, qtx11extras, wrapQtAppsHook
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionalString optional optionals;
  hostIsAarch = stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64;
in
stdenv.mkDerivation rec {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.16";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${version}/vlc-${version}.tar.xz";
    sha256 = "sha256-/641/GT2JcF1Vx0jRrxfYge+mXYlF/FUI+dPGDmUEPY=";
  };

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    SDL
    SDL_image
    a52dec
    alsa-lib
    avahi
    dbus
    faad2
    ffmpeg
    flac
    fluidsynth
    fribidi
    gnutls
    libarchive
    libass
    libbluray
    libcaca
    libcddb
    libdc1394
    libdvbpsi
    libdvdnav
    libdvdnav.libdvdread
    libebml
    libgcrypt
    libgpg-error
    libkate
    libmad
    libmatroska
    libmtp
    liboggz
    libopus
    libpulseaudio
    libraw1394
    librsvg
    libsamplerate
    libspatialaudio
    libssh2
    libtheora
    libtiger
    libupnp
    libv4l
    libva
    libvdpau
    libvorbis
    libxml2
    lua5
    mpeg2dec
    ncurses
    samba
    schroedinger
    speex
    srt
    systemd
    taglib
    zlib
  ]
  ++ (with xorg; [
    libXpm
    libXv
    libXvMC
    xcbutilkeysyms
    xlibsWrapper
  ])
  ++ optional (!hostIsAarch && !onlyLibVLC) live555
  ++ optional jackSupport libjack2
  ++ optionals chromecastSupport [ libmicrodns protobuf ]
  ++ optionals skins2Support (with xorg; [
    freetype
    libXext
    libXinerama
    libXpm
  ])
  ++ optionals waylandSupport [ wayland wayland-protocols ]
  ++ optionals withQt5 [ qtbase qtsvg qtx11extras ]
  ++ optional (waylandSupport && withQt5) qtwayland;

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    removeReferencesTo
    unzip
  ]
  ++ optionals withQt5 [ wrapQtAppsHook ]
  ++ optionals waylandSupport [ wayland wayland-protocols ];

  enableParallelBuilding = true;

  LIVE555_PREFIX = if hostIsAarch then null else live555;

  # vlc depends on a c11-gcc wrapper script which we don't have so we need to
  # set the path to the compiler
  BUILDCC = "${stdenv.cc}/bin/gcc";

  patches = [
    # Required in order to run newer srt plugin. Remove it when next release arrives
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/4250fe8f28c220d883db454cec2b2c76a07473eb/trunk/vlc-3.0.11.1-srt_1.4.2.patch";
      sha256 = "53poWjZfwq/6l316sqiCp0AtcGweyXBntcLDFPSokHQ=";
    })
    # patches to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/3c84ea58d7b94d7a8d354eaffe4b7d55/0001-Get-addr-by-ref.-from-getConnectionEndpointAddress.patch";
      sha256 = "171d3qjl9a4dm13sqig3ra8s2zcr76wfnqz4ba4asg139cyc1axd";
    })
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      sha256 = "0kyi8q2zn2ww148ngbia9c7qjgdrijf4jlvxyxgrj29cb5iy1kda";
    })
  ];

  postPatch = ''
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h --replace \
      /usr/share/fonts/truetype/freefont ${freefont_ttf}/share/fonts/truetype
  '';

  # - Touch plugins (plugins cache keyed off mtime and file size:
  #     https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  # - Remove references to the Qt development headers (used in error messages)
  postFixup = ''
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    $out/lib/vlc/vlc-cache-gen $out/vlc/plugins
  '' + optionalString withQt5 ''
    remove-references-to -t "${qtbase.dev}" $out/lib/vlc/plugins/gui/libqt_plugin.so
  '';

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--enable-srt" # Explicit enable srt to ensure the patch is applied.
    "--with-kde-solid=$out/share/apps/solid/actions"
  ]
  ++ optional onlyLibVLC "--disable-vlc"
  ++ optional skins2Support "--enable-skins2"
  ++ optional waylandSupport "--enable-wayland"
  ++ optionals chromecastSupport [
    "--enable-sout"
    "--enable-chromecast"
    "--enable-microdns"
  ];

  # Remove runtime dependencies on libraries
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  # Add missing SOFA files
  # Given in EXTRA_DIST, but not in install-data target
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
  '';

  meta = with lib; {
    description = "Cross-platform media player and streaming server";
    homepage = "http://www.videolan.org/vlc/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
