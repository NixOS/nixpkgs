{
  lib,
  fetchurl,
  buildPythonApplication,
  libjack2,
  pyliblo3,
  pyqt5,
  which,
  bash,
  qt5,
}:

buildPythonApplication rec {
  pname = "raysession";
  version = "0.14.4";

  src = fetchurl {
    url = "https://github.com/Houston4444/RaySession/releases/download/v${version}/RaySession-${version}-source.tar.gz";
    sha256 = "sha256-cr9kqZdqY6Wq+RkzwYxNrb/PLFREKUgWeVNILVUkc7A=";
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
    pyqt5 # pyuic5 and pyrcc5 to build resources.
    qt5.qttools # lrelease to build translations.
    which # which to find lrelease.
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    libjack2
    bash
  ];
  dependencies = [
    pyliblo3
    pyqt5
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

  meta = with lib; {
    homepage = "https://github.com/Houston4444/RaySession";
    description = "Session manager for Linux musical programs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
