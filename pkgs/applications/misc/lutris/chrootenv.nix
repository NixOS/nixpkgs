{ lib, buildFHSUserEnv, lutris-unwrapped
, steamSupport ? true
}:

let

  qt5Deps = pkgs: with pkgs.qt5; [ qtbase qtmultimedia ];
  gnome3Deps = pkgs: with pkgs; [ gnome3.zenity gtksourceview gnome3.gnome-desktop gnome3.libgnome-keyring webkitgtk ];
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

    # PPSSPP
    glew snappy

    # Redream // "redream is not available for the x86_64 architecture"

    # ResidualVM
    flac

    # rpcs3 // TODO: "error while loading shared libraries: libz.so.1..."
    llvm

    # ScummVM
    nasm sndio

    # Snes9x
    epoxy minizip

    # Vice
    bison flex

    # WINE
    xorg.xrandr perl which p7zip gnused gnugrep psmisc opencl-headers

    # ZDOOM
    soundfont-fluid bzip2 game-music-emu
  ] ++ qt5Deps pkgs
    ++ gnome3Deps pkgs
    ++ lib.optional steamSupport pkgs.steam;

  multiPkgs = pkgs: with pkgs; [
    # Common
    libsndfile libtheora libogg libvorbis libopus libGLU libpcap libpulseaudio
    libao libusb libevdev udev libgcrypt libxml2 libusb libpng libmpeg2 libv4l
    libjpeg libxkbcommon libass libcdio libjack2 libsamplerate libzip libmad libaio
    libcap libtiff libva libgphoto2 libxslt libsndfile giflib zlib glib
    alsaLib zziplib bash dbus keyutils zip cabextract freetype unzip coreutils
    readline gcc SDL SDL2 curl graphite2 gtk2 gtk3 udev ncurses wayland libglvnd
    vulkan-loader xdg_utils sqlite gnutls libbsd

    # PCSX2 // TODO: "libgobject-2.0.so.0: wrong ELF class: ELFCLASS64"

    # WINE
    cups lcms2 mpg123 cairo unixODBC samba4 sane-backends openldap
    ocl-icd utillinux libkrb5

    # Winetricks
    fribidi
  ] ++ xorgDeps pkgs;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${lutris-unwrapped}/share/applications $out/share
    ln -sf ${lutris-unwrapped}/share/icons $out/share
  '';
}
