{ lib
, fetchurl
, fsuae
, gettext
, python3Packages
, stdenv
, libsForQt5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher";
  version = "3.1.68";

  src = fetchurl {
    url = "https://fs-uae.net/files/FS-UAE-Launcher/Stable/${finalAttrs.version}/fs-uae-launcher-${finalAttrs.version}.tar.xz";
    hash = "sha256-42EERC2yeODx0HPbwr4vmpN80z6WSWi3WzJMOT+OwDA=";
  };

  nativeBuildInputs = [
    gettext
    python3Packages.python
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with python3Packages; [
    pyqt5
    requests
    setuptools
  ];

  strictDeps = true;

  makeFlags = [ "prefix=$(out)" ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/fs-uae-launcher" \
      --set PYTHONPATH "$PYTHONPATH"

    # fs-uae-launcher search side by side for executables and shared files
    # see $src/fsgs/plugins/pluginexecutablefinder.py#find_executable
    ln -s ${fsuae}/bin/fs-uae $out/bin
    ln -s ${fsuae}/bin/fs-uae-device-helper $out/bin
    ln -s ${fsuae}/share/fs-uae $out/share/fs-uae
  '';

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fs-uae-launcher";
    maintainers = with lib.maintainers; [ sander AndersonTorres ];
    platforms = with lib.systems.inspect;
      patternLogicalAnd patterns.isx86 patterns.isLinux;
  };
})
