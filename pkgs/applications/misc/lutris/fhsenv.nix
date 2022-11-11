{ lib, buildFHSUserEnv, lutris-unwrapped
, extraPkgs ? pkgs: [ ]
, extraLibraries ? pkgs: [ ]
, steamSupport ? true
}:

let

  qt5Deps = pkgs: with pkgs.qt5; [ qtbase qtmultimedia ];
  gnomeDeps = pkgs: with pkgs; [ gnome.zenity gtksourceview gnome-desktop gnome.libgnome-keyring webkitgtk ];
  xorgDeps = pkgs: with pkgs.xorg; [
    libX11 libXrender libXrandr libxcb libXmu libpthreadstubs libXext libXdmcp
    libXxf86vm libXinerama libSM libXv libXaw libXi libXcursor libXcomposite
  ];

in buildFHSUserEnv {
  name = "lutris";

  runScript = "lutris";

  targetPkgs = pkgs: with pkgs; [
    lutris-unwrapped

    # Adventure Game Studio
    allegro dumb

    # Desmume
    lua agg soundtouch openal desktop-file-utils atk

    # DGen // TODO: libarchive is broken

    # Dolphin
    bluez ffmpeg gettext portaudio wxGTK30 miniupnpc mbedtls lzo sfml gsm
    wavpack orc nettle gmp pcre vulkan-loader

    # DOSBox
    SDL_net SDL_sound

    # GOG
    glib-networking

    # Higan // TODO: "higan is not available for the x86_64 architecture"

    # Libretro
    fluidsynth hidapi mesa libdrm

    # MAME
    qt48 fontconfig SDL2_ttf

    # Mednafen
    freeglut mesa_glu

    # MESS
    expat

    # Minecraft
    nss

    # Mupen64Plus
    boost dash

    # Osmose
    qt4

    # Overwatch 2
    libunwind

    # PPSSPP
    glew snappy

    # Redream // "redream is not available for the x86_64 architecture"


    # rpcs3 // TODO: "error while loading shared libraries: libz.so.1..."
    llvm

    # ScummVM
    nasm sndio

    # ResidualVM is now merged with ScummVM and therefore does not exist anymore
    flac

    # Snes9x
    libepoxy minizip

    # Vice
    bison flex

    # WINE
    xorg.xrandr perl which p7zip gnused gnugrep psmisc opencl-headers

    # ZDOOM
    soundfont-fluid bzip2 game-music-emu
  ] ++ qt5Deps pkgs
    ++ gnomeDeps pkgs
    ++ lib.optional steamSupport pkgs.steam
    ++ extraPkgs pkgs;

  multiPkgs = pkgs: with pkgs; [
    # Common
    libsndfile libtheora libogg libvorbis libopus libGLU libpcap libpulseaudio
    libao libevdev udev libgcrypt libxml2 libusb-compat-0_1 libpng libmpeg2 libv4l
    libjpeg libxkbcommon libass libcdio libjack2 libsamplerate libzip libmad libaio
    libcap libtiff libva libgphoto2 libxslt libsndfile giflib zlib glib
    alsa-lib zziplib bash dbus keyutils zip cabextract freetype unzip coreutils
    readline gcc SDL SDL2 curl graphite2 gtk2 gtk3 udev ncurses wayland libglvnd
    vulkan-loader xdg-utils sqlite gnutls p11-kit libbsd harfbuzz

    # PCSX2 // TODO: "libgobject-2.0.so.0: wrong ELF class: ELFCLASS64"

    # WINE
    cups lcms2 mpg123 cairo unixODBC samba4 sane-backends openldap
    ocl-icd util-linux libkrb5

    # Proton
    libselinux

    # Winetricks
    fribidi
  ] ++ xorgDeps pkgs
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
      broken;

    mainProgram = "lutris";
  };
}
