{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "cfclient";
  version = "2025.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitcraze";
    repo = "crazyflie-clients-python";
    tag = version;
    hash = "sha256-LCGTMLIfGH59KFwQACyuEQTh/zkGgzXd3e6MkFTgKhA=";
  };

  strictDeps = true;

  buildInputs = [
    qt6.qtbase
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "numpy"
    "pyqt6"
    "pyzmq"
    "vispy"
  ];

  dependencies = with python3Packages; [
    appdirs
    cflib
    numpy
    pyopengl
    pyserial
    pysdl2
    pyqtgraph
    pyqt6
    pyqt6-sip
    pyyaml
    pyzmq
    scipy
    setuptools
    vispy
  ];

  # No tests
  doCheck = false;

  # Use wrapQtApp for Python scripts as the manual mentions that wrapQtAppsHook only applies to binaries
  postFixup = ''
    wrapQtApp "$out/bin/cfclient" \
      --set QT_QPA_PLATFORM "wayland" \
      --set XDG_CURRENT_DESKTOP "Wayland" \
      ''${qtWrapperArgs[@]}
  '';

  meta = {
    description = "Host applications and library for Crazyflie drones written in Python";
    homepage = "https://github.com/bitcraze/crazyflie-clients-python";
    changelog = "https://github.com/bitcraze/crazyflie-clients-python/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
}
