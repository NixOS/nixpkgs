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
  fetchurl,
  lib,
  writeScript,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gcdemu";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/gcdemu-${finalAttrs.version}.tar.xz";
    hash = "sha256-C9d4Rv47kQhs2kbTCwAUcdm+dcljA8IVkwhLJHJpUS0=";
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

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  pyproject = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = writeScript "update-gcdemu" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Fetch the latest version from the SourceForge RSS feed for gcdemu
      newVersion="$(curl -s "https://sourceforge.net/projects/cdemu/rss?path=/gcdemu" | pcre2grep -o1 'gcdemu-([0-9.]+)\.tar\.xz' | head -n 1)"

      update-source-version gcdemu "$newVersion"
    '';
  };

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
})
