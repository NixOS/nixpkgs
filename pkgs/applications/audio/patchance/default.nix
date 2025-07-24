{
  lib,
  python3Packages,
  fetchurl,
  libjack2,
  qt5,
  which,
  bash,
}:

python3Packages.buildPythonApplication rec {
  pname = "patchance";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/Houston4444/Patchance/releases/download/v${version}/Patchance-${version}-source.tar.gz";
    sha256 = "sha256-wlkEKkPH2C/y7TQicIVycWbtLUdX2hICcUWi7nFN51w=";
  };

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
  propagatedBuildInputs = with python3Packages; [ pyqt5 ];

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
