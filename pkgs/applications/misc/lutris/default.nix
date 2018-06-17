{ stdenv, pkgs, buildFHSUserEnv, makeDesktopItem, fetchFromGitHub, fetchpatch
, wrapGAppsHook, python2Packages, python3Packages }:

let
  qt5Deps = with pkgs; with qt5; [ qtbase qtmultimedia ];
  gnome2Deps = with pkgs; with gnome2; [ libglade gtkglext ];
  gnome3Deps = with pkgs; with gnome3; [ zenity ];
  python2Deps = with pkgs; with python2Packages; [ pygtk ];

  python3Deps = with pkgs; with python3Packages; [
    evdev pyyaml pyxdg pygobject3 pyqt5 dbus-python
  ];

  xorgDeps = with pkgs; with xorg; [
    libX11 libXrender libXrandr libxcb libXmu libpthreadstubs libXext libXdmcp
    libXxf86vm libXinerama libSM xrandr
  ];

  deps = with pkgs; [
    # Common
    libGL libGLU_combined libsndfile libtheora libogg libvorbis libopus libGLU
    libpcap libpulseaudio libao libusb libevdev libudev libgcrypt libxml2 libusb
    zlib alsaLib glib zziplib keyutils bash cabextract freetype curl unzip dbus
    coreutils readline SDL SDL2 graphite2 gtk2 gtk3

    # Lutris
    gobjectIntrospection gdk_pixbuf pango openssl sqlite xterm

    # Adventure Game Studio
    allegro dumb

    # Desmume
    lua agg soundtouch openal desktop-file-utils pangox_compat atk

    # DGen
    # TODO: libarchive is broken

    # Dolphin
    bluez ffmpeg gettext portaudio wxGTK30 miniupnpc mbedtls lzo sfml gsm
    wavpack gnutls-kdh orc nettle gmp pcre vulkan-loader

    # WINE
    wine perl which p7zip gnused gnugrep
  ] ++ qt5Deps
    ++ gnome2Deps
    ++ gnome3Deps
    ++ python2Deps
    ++ python3Deps
    ++ xorgDeps;

  lutris = python3Packages.buildPythonApplication rec {
    name = "lutris-${version}";
    version = "v0.4.18";

    src = fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = version;
      sha256 = "1pgvk3qaaph1dlkrc5cq2jifr3yqlhnqsfa0wkaqzssh9acd5q9b";
    };

    patches = [(fetchpatch {
      url = "https://github.com/lutris/lutris/commit/403a83e18690511cb723f883254c86081870f050.patch";
      sha256 = "1zc45jgaqvpqgr6f9mkqzcwx48lffrjkp7zfk0fz4l2a05jim6hm";
    })];

    enableParallelBuilding = true;
    nativeBuildInputs = [ wrapGAppsHook ];
    propagatedBuildInputs = deps;
    python2Path = python2Deps;
    fullPath = stdenv.lib.makeLibraryPath deps;
    preConfigure = "export HOME=$PWD";

    makeWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${fullPath}:$out/lib"
      "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
      "--prefix XDG_DATA_DIRS : $out/share"
      "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    ];

    postInstall = ''
      mkdir -p $out/lib
      ln -sf ${pkgs.gsm}/lib/libgsm.so $out/lib/libgsm.so.1
      mv $out/bin/lutris $out/bin/lutris-${version}
    '';

    meta = with stdenv.lib; {
      homepage = "https://lutris.net";
      description = "Open Source gaming platform for GNU/Linux";
      license = licenses.gpl3;
      maintainers = with maintainers; [ chiiruno ];
      platforms = platforms.linux;
    };
  };

  desktopItem = makeDesktopItem {
    name = "Lutris";
    exec = "lutris";
    icon = "lutris";
    comment = lutris.meta.description;
    desktopName = "Lutris";
    genericName = "Gaming Platform";
    categories = "Network;Game;Emulator;";
    startupNotify = "false";
  };
in buildFHSUserEnv rec {
  name = "lutris";
  runScript = "lutris-${lutris.version}";
  targetPkgs = pkgs: [ lutris ];

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -r ${desktopItem}/share/applications $out/share
    ln -sf ${lutris}/share/icons $out/share
  '';
}
