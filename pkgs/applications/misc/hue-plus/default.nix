{
  python3Packages,
  fetchFromGitHub,
  lib,
  wrapQtAppsHook,
  qtbase,
}:

python3Packages.buildPythonApplication rec {
  pname = "hue-plus";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "kusti8";
    repo = pname;
    rev = "7ce7c4603c6d0ab1da29b0d4080aa05f57bd1760";
    sha256 = "sha256-dDIJXhB3rmKnawOYJHE7WK38b0M5722zA+yLgpEjDyI=";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    pyserial
    pyqt5
    pyaudio
    appdirs
    setuptools
  ];

  doCheck = false;
  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/kusti8/hue-plus";
    description = "Windows and Linux driver in Python for the NZXT Hue+";
    longDescription = ''
      A cross-platform driver in Python for the NZXT Hue+. Supports all functionality except FPS, CPU, and GPU lighting.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ garaiza-93 ];
  };
}
