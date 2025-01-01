{
  lib,
  fetchurl,
  buildPythonApplication,
  libjack2,
  pyqt5,
  qt5,
  which,
  bash,
}:

buildPythonApplication rec {
  pname = "patchance";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/Houston4444/Patchance/releases/download/v${version}/Patchance-${version}-source.tar.gz";
    sha256 = "sha256-wlkEKkPH2C/y7TQicIVycWbtLUdX2hICcUWi7nFN51w=";
  };

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
  propagatedBuildInputs = [ pyqt5 ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeWrapperArgs = [
    "--suffix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ libjack2 ])
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/patchance/src" "$out $pythonPath"
    for file in $out/bin/*; do
      wrapQtApp "$file"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/Houston4444/Patchance";
    description = "JACK Patchbay GUI";
    mainProgram = "patchance";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
