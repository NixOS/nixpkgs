{
  python3Packages,
  cmake,
  pkg-config,
  intltool,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  fetchurl,
  lib,
  writeScript,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cdemu-client";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/cdemu-client-${finalAttrs.version}.tar.xz";
    hash = "sha256-py2F61v8vO0BCM18GCflAiD48deZjbMM6wqoCDZsOd8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pygobject3
  ];

  pyproject = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = writeScript "update-cdemu-client" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Fetch the latest version from the SourceForge RSS feed for cdemu-client
      newVersion="$(curl -s "https://sourceforge.net/projects/cdemu/rss?path=/cdemu-client" | pcre2grep -o1 'cdemu-client-([0-9.]+)\.tar\.xz' | head -n 1)"

      update-source-version cdemu-client "$newVersion"
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
