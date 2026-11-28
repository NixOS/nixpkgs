{ lib
, fetchPypi
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "bauh";
  version = "0.10.7";
  pyproject = true;

  src= fetchPypi{
    inherit pname version;
    hash = "sha256-N6zvEbx0Y2GGB9f5emmhNcWN6z0oPK0qoazKq0gIRC0=";
  };

  build-system = with python3Packages; [
    build
    installer
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    colorama
    dateutil
    pyaml
    pyqt5
    requests
  ];

  meta = with lib; {
    description = "GUI for managing your Linux applications. Supports AppImage, Debian, Arch, Flatpak, Snap and Web apps";
    homepage = "https://github.com/vinifmor/bauh";
    license = licenses.zlib;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "bauh";
    platforms = platforms.unix;
  };
}
