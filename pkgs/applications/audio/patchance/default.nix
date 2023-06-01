{ lib, fetchurl, buildPythonApplication, libjack2, pyqt5, qttools, which }:

buildPythonApplication rec {
  pname = "patchance";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/Houston4444/Patchance/releases/download/v${version}/Patchance-${version}-source.tar.gz";
    sha256 = "sha256-8Zn6xcDv4hBFXnaXK9xslYEB8uHEfIP+1NKvcPAyHj0=";
  };

  format = "other";

  nativeBuildInputs = [
    pyqt5   # pyuic5 and pyrcc5 to build resources.
    qttools # lrelease to build translations.
    which   # which to find lrelease.
  ];
  buildInputs = [ libjack2 ];
  propagatedBuildInputs = [ pyqt5 ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeWrapperArgs = [
    "--prefix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath [ libjack2 ])
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/share/patchance/src" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/Houston4444/Patchance";
    description = "JACK Patchbay GUI";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
