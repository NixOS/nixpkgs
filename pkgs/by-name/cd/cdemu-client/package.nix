{
  python3Packages,
  cmake,
  pkg-config,
  intltool,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  lib,
  fetchurl,
}:
python3Packages.buildPythonApplication rec {

  pname = "cdemu-client";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/cdemu-client-${version}.tar.xz";
    hash = "sha256-py2F61v8vO0BCM18GCflAiD48deZjbMM6wqoCDZsOd8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
    wrapGAppsNoGuiHook
    gobject-introspection
  ];
  dependencies = with python3Packages; [
    dbus-python
    pygobject3
  ];

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
