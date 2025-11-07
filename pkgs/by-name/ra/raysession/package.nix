{
  lib,
  fetchurl,
  python3Packages,
  libjack2,
  which,
  bash,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "raysession";
  version = "0.14.4";

  src = fetchurl {
    url = "https://github.com/Houston4444/RaySession/releases/download/v${version}/RaySession-${version}-source.tar.gz";
    hash = "sha256-cr9kqZdqY6Wq+RkzwYxNrb/PLFREKUgWeVNILVUkc7A=";
  };

  postPatch = ''
    # Fix installation path of xdg schemas.
    substituteInPlace Makefile --replace '$(DESTDIR)/' '$(DESTDIR)$(PREFIX)/'
    # Do not wrap an importable module with a shell script.
    chmod -x src/daemon/desktops_memory.py
    chmod -x src/clients/jackpatch/main_loop.py
  '';

  format = "other";

  nativeBuildInputs = [
    python3Packages.pyqt5 # pyuic5 and pyrcc5 to build resources.
    qt5.qttools # lrelease to build translations.
    which # which to find lrelease.
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    libjack2
    bash
  ];
  dependencies = [
    python3Packages.pyliblo3
    python3Packages.pyqt5
  ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeWrapperArgs = [
    "--suffix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ libjack2 ])
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/share/raysession/src" "$out $pythonPath"
    for file in $out/bin/*; do
      wrapQtApp "$file"
    done
  '';

  meta = {
    homepage = "https://github.com/Houston4444/RaySession";
    description = "Session manager for Linux musical programs";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
