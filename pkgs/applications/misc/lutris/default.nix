{ stdenv, pkgs, buildFHSUserEnv, makeDesktopItem, fetchFromGitHub
, wrapGAppsHook, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication evdev pyyaml pyxdg pygobject3
    dbus-python;

  deps = with pkgs; with xorg; [
    stdenv.cc.cc gtk2 gtk3 gobjectIntrospection gdk_pixbuf cairo glib pango zlib
    openssl python3 polkit wine desktop-file-utils hicolor-icon-theme cabextract
    evdev pyxdg pyyaml pygobject3 dbus-python sqlite xrandr xterm libX11 libGL
    libXrandr libxml2 SDL alsaLib dbus pulseaudio harfbuzz freetype psmisc atk
    bluez ffmpeg libao libGLU_combined pcre gettext libpthreadstubs libXext
    libXxf86vm libXinerama libSM readline openal libXdmcp portaudio libusb
    libevdev curl qt5.qtbase vulkan-loader libpulseaudio graphite2 libsndfile
  ];

  lutris = buildPythonApplication rec {
    name = "lutris-${version}";
    version = "v0.4.18";
    enableParallelBuilding = true;
    nativeBuildInputs = [ wrapGAppsHook ];
    propagatedBuildInputs = deps;
    fullPath = stdenv.lib.makeLibraryPath deps;
    preConfigure = "export HOME=$PWD";

    src = fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = version;
      sha256 = "1pgvk3qaaph1dlkrc5cq2jifr3yqlhnqsfa0wkaqzssh9acd5q9b";
    };

    makeWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${fullPath}:$out/lib"
      "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
      "--prefix XDG_DATA_DIRS : $out/share"
      "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    ];

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
  runScript = "lutris";
  targetPkgs = pkgs: [ lutris ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
}
