{
  cmake,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook3,
  python3Packages,
  libxml2,
  gnuplot,
  adwaita-icon-theme,
  gdk-pixbuf,
  intltool,
  libmirage,
  lib,
  fetchurl,
}:
python3Packages.buildPythonApplication rec {

  pname = "image-analyzer";
  version = "3.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/image-analyzer-${version}.tar.xz";
    hash = "sha256-7I8RUgd+k3cEzskJGbziv1f0/eo5QQXn62wGh/Y5ozc=";
  };
  buildInputs = [
    libxml2
    gnuplot
    libmirage
    adwaita-icon-theme
    gdk-pixbuf
  ];
  propagatedBuildInputs = with python3Packages; [
    pygobject3
    matplotlib
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    intltool
    gobject-introspection
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
