{
  lib,
  buildFHSEnv,
  lutris-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  steamSupport ? true,
}:

let

  qt5Deps =
    pkgs: with pkgs.qt5; [
      qtbase
      qtmultimedia
    ];
  qt6Deps = pkgs: with pkgs.qt6; [ qtbase ];
  gnomeDeps =
    pkgs: with pkgs; [
      zenity
      gtksourceview3
      gnome-desktop
      libgnome-keyring
      webkitgtk_4_1
      adwaita-icon-theme
    ];
  xorgDeps =
    pkgs: with pkgs; [
      libx11
      libxrender
      libxrandr
      libxcb
      libxmu
      libpthread-stubs
      libxext
      libxdmcp
      libxxf86vm
      libxinerama
      libsm
      libxv
      libxaw
      libxi
      libxcursor
      libxcomposite
      libxfixes
      libxtst
      libxscrnsaver
      libice
      libxt
    ];
  gstreamerDeps =
    pkgs: with pkgs.gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-plugins-bad
      gst-libav
    ];

in
buildFHSEnv {
  pname = "lutris";
  inherit (lutris-unwrapped) version;

  runScript = "lutris";

  # Many native and WINE games need 32bit
  multiArch = true;

  targetPkgs =
    pkgs:
    with pkgs;
    [
      lutris-unwrapped

      # XKB data for Qt/Wayland
      # PCSX2's AppImage expects /usr/share/X11/xkb
      xkeyboard-config

      # Appimages
      fuse

      # Adventure Game Studio
      allegro

      # Battle.net
      jansson

      # Curl
      libnghttp2

      # Desmume
      lua5_2_compat
      agg
      soundtouch
      openal
      desktop-file-utils
      atk

      # DGen // TODO: libarchive is broken

      # DOSBox
      SDL_net
      SDL_sound

      # GOG
      glib-networking

      # Higan // TODO: "higan is not available for the x86_64 architecture"

      # Libretro
      fluidsynth
      hidapi
      libgbm
      libdrm

      # MAME
      fontconfig
      SDL2_ttf

      # Mednafen
      libglut
      mesa_glu

      # MESS
      expat

      # Minecraft
      nss

      # Mupen64Plus
      boost
      dash

      # Overwatch 2
      libunwind

      # PPSSPP
      glew
      snappy

      # Redream // "redream is not available for the x86_64 architecture"

      # RPCS3
      llvm
      e2fsprogs
      libgpg-error
      gmp # PCSX2 needs it too

      # ScummVM
      nasm
      sndio

      # ResidualVM is now merged with ScummVM and therefore does not exist anymore
      flac

      # Snes9x
      libepoxy
      minizip

      # Vice
      bison
      flex

      # WINE
      xrandr
      perl
      which
      p7zip
      gnused
      gnugrep
      psmisc
      opencl-headers

      # ZDOOM
      soundfont-fluid
      bzip2
      game-music-emu
    ]
    ++ qt5Deps pkgs
    ++ qt6Deps pkgs
    ++ gnomeDeps pkgs
    ++ lib.optional steamSupport pkgs.steam
    ++ extraPkgs pkgs;

  multiPkgs =
    pkgs:
    with pkgs;
    [
      # Common
      libsndfile
      libtheora
      libogg
      libvorbis
      libopus
      libGLU
      libpcap
      libpulseaudio
      libao
      libevdev
      udev
      libgcrypt
      libxml2
      libusb1
      libpng
      libmpeg2
      libv4l
      libjpeg
      libxkbcommon
      libass
      libcdio
      libjack2
      libsamplerate
      libzip
      libmad
      libaio
      libcap
      libtiff
      libva
      libgphoto2
      libxslt
      libsndfile
      giflib
      zlib
      glib
      alsa-lib
      zziplib
      bash
      dbus
      keyutils
      zip
      cabextract
      freetype
      unzip
      coreutils
      readline
      gcc
      SDL
      SDL2
      curl
      graphite2
      gtk3
      udev
      ncurses
      wayland
      libglvnd
      vulkan-loader
      xdg-utils
      sqlite
      gnutls
      p11-kit
      libbsd
      harfbuzz

      # WINE
      cups
      lcms2
      mpg123
      cairo
      unixodbc
      samba4
      sane-backends
      openldap
      ocl-icd
      util-linux
      libkrb5

      # Proton
      libselinux

      # Winetricks
      fribidi
      pango
      libadwaita
      gtk4
    ]
    ++ xorgDeps pkgs
    ++ gstreamerDeps pkgs
    ++ extraLibraries pkgs;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${lutris-unwrapped}/share/applications $out/share
    ln -sf ${lutris-unwrapped}/share/icons $out/share
  '';

  # allows for some gui applications to share IPC
  # this fixes certain issues where they don't render correctly
  unshareIpc = false;

  # Some applications such as Natron need access to MIT-SHM or other
  # shared memory mechanisms. Unsharing the pid namespace
  # breaks the ability for application to reference shared memory.
  unsharePid = false;

  meta = {
    inherit (lutris-unwrapped.meta)
      homepage
      description
      platforms
      license
      maintainers
      broken
      ;

    mainProgram = "lutris";
  };
}
