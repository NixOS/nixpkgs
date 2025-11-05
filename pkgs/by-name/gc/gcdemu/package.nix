{
  cmake,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  python3Packages,
  libnotify,
  intltool,
  adwaita-icon-theme,
  gdk-pixbuf,
  libappindicator-gtk3,
  lib,
  fetchurl,
}:
python3Packages.buildPythonApplication rec {

  pname = "gcdemu";
  version = "3.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/gcdemu-${version}.tar.xz";
    hash = "sha256-w4vzKoSotL5Cjfr4Cu4YhNSWXJqS+n/vySrwvbhR1zA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    intltool
    gobject-introspection
  ];
  buildInputs = [
    libnotify
    adwaita-icon-theme
    gdk-pixbuf
    libappindicator-gtk3
  ];
  dependencies = with python3Packages; [ pygobject3 ];

  pyproject = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Suite of tools for emulating optical drives and discs";
    longDescription = ''
      CDEmu consists of:

      - a kernel module implementing a virtual drive-controller
      - libmirage which is a software library for interpreting optical disc images
      - a daemon which emulates the functionality of an optical drive+disc
      - textmode and GTK clients for controlling the emulator
      - an image analyzer to view the structure of image files

      Optical media emulated by CDemu can be mounted within Linux. Automounting is also allowed.
    '';
    homepage = "https://cdemu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
