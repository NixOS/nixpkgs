{ lib
, stdenv
, pkgsBuildBuild
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
, ffmpeg_4
, flac
, fluidsynth
, freefont_ttf
, freetype
, fribidi
, gnutls
, libSM
, libXext
, libXinerama
, libXpm
, libXv
, libXvMC
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
, libmicrodns
, libmodplug
, libmtp
, liboggz
, libopus
, libplacebo
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
, protobuf
, qtbase
, qtsvg
, qtwayland
, qtx11extras
, removeReferencesTo
, samba
, schroedinger
, speex
, srt
, systemd
, taglib
, unzip
, wayland
, wayland-protocols
, wrapGAppsHook
, wrapQtAppsHook
, xcbutilkeysyms
, zlib

, chromecastSupport ? true
, jackSupport ? false
, onlyLibVLC ? false
, skins2Support ? !onlyLibVLC
, waylandSupport ? true
, withQt5 ? true
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

let
  inherit (lib) optionalString optional optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "3.0.18";

  src = fetchurl {
    url = "http://get.videolan.org/vlc/${finalAttrs.version}/vlc-${finalAttrs.version}.tar.xz";
    hash = "sha256-VwlEOcNl2KqLm0H6MIDMDu8r7+YCW7XO9yKszGJa7ew=";
  };

  nativeBuildInputs = [
    autoreconfHook
    lua5
    perl
    pkg-config
    removeReferencesTo
    unzip
    wrapGAppsHook
  ]
  ++ optional chromecastSupport protobuf
  ++ optionals withQt5 [ wrapQtAppsHook ]
  ++ optionals waylandSupport [
    wayland
    wayland-protocols
  ];

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
    ffmpeg_4
    flac
    fluidsynth
    fribidi
    gnutls
    libSM
    libXpm
    libXv
    libXvMC
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
    libmodplug
    libmtp
    liboggz
    libopus
    libplacebo
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
    xcbutilkeysyms
    zlib
  ]
  ++ optional (!stdenv.hostPlatform.isAarch && !onlyLibVLC) live555
  ++ optional jackSupport libjack2
  ++ optionals chromecastSupport [ libmicrodns protobuf ]
  ++ optionals skins2Support [
    freetype
    libXext
    libXinerama
    libXpm
  ]
  ++ optionals waylandSupport [ wayland wayland-protocols ]
  ++ optionals withQt5 [ qtbase qtsvg qtx11extras ]
  ++ optional (waylandSupport && withQt5) qtwayland;

  env = {
    # vlc depends on a c11-gcc wrapper script which we don't have so we need to
    # set the path to the compiler
    BUILDCC = "${pkgsBuildBuild.stdenv.cc}/bin/gcc";
    PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER = "wayland-scanner";
  } // lib.optionalAttrs (!stdenv.hostPlatform.isAarch) {
    LIVE555_PREFIX = live555;
  };

  patches = [
    # patch to build with recent live555
    # upstream issue: https://code.videolan.org/videolan/vlc/-/issues/25473
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/uploads/eb1c313d2d499b8a777314f789794f9d/0001-Add-lssl-and-lcrypto-to-liblive555_plugin_la_LIBADD.patch";
      sha256 = "0kyi8q2zn2ww148ngbia9c7qjgdrijf4jlvxyxgrj29cb5iy1kda";
    })
    # patch to build with recent libplacebo
    # https://code.videolan.org/videolan/vlc/-/merge_requests/3027
    (fetchpatch {
      url = "https://code.videolan.org/videolan/vlc/-/commit/65ea8d19d91ac1599a29e8411485a72fe89c45e2.patch";
      hash = "sha256-Zz+g75V6X9OZI3sn614K9Uenxl3WtRHKSdLkWP3b17w=";
    })
  ];

  postPatch = ''
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h --replace \
      /usr/share/fonts/truetype/freefont ${freefont_ttf}/share/fonts/truetype
  '' + lib.optionalString (!stdenv.hostPlatform.canExecute stdenv.buildPlatform) ''
    # Upstream luac can't cross compile, so we have to install the lua
    # sources, not bytecode:
    # https://www.lua.org/wshop13/Jericke.pdf#page=39
    substituteInPlace share/Makefile.am --replace $'.luac \\\n' $'.lua \\\n'
  '';

  enableParallelBuilding = true;

  dontWrapGApps = true; # to prevent double wrapping of Qtwrap and Gwrap

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # - Touch plugins (plugins cache keyed off mtime and file size:
  #     https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  # - Remove references to the Qt development headers (used in error messages)
  #
  # pkgsBuildBuild is used here because buildPackages.libvlc somehow
  # depends on a qt5.qttranslations that doesn't build, even though it
  # should be the same as pkgsBuildBuild.qt5.qttranslations.
  postFixup = ''
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    ${if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "$out" else pkgsBuildBuild.libvlc}/lib/vlc/vlc-cache-gen $out/vlc/plugins
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

  # fails on high core machines
  # ld: cannot find -lvlc_vdpau: No such file or directory
  # https://code.videolan.org/videolan/vlc/-/issues/27338
  enableParallelInstalling = false;

  # Add missing SOFA files
  # Given in EXTRA_DIST, but not in install-data target
  postInstall = ''
    cp -R share/hrtfs $out/share/vlc
  '';

  meta = {
    description = "Cross-platform media player and streaming server";
    homepage = "http://www.videolan.org/vlc/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
