{
  stdenv,
  lib,
  billiard,
  buildPythonApplication,
  fetchFromGitHub,
  fetchpatch,
  gnureadline,
  lxml,
  matplotlib,
  numpy,
  opencv-python,
  pymavlink,
  pynmeagps,
  pyserial,
  setuptools,
  versionCheckHook,
  wxpython,
}:

buildPythonApplication rec {
  pname = "MAVProxy";
  version = "1.8.74";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "MAVProxy";
    tag = "v${version}";
    hash = "sha256-1/bp3vlCXt4Hg36zwMKSzPSxW7xlxpfx2o+2uQixdos=";
  };

  patches = [
    # Remove python 2 future imports
    (fetchpatch {
      url = "https://github.com/ArduPilot/MAVProxy/commit/db52f3f5d1991942026c00b51a3ce1ce85998cbd.patch";
      hash = "sha256-mNhOfXJMiUihsso3fjzlbeXW/3ENvrdkFSLo23dMCY4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    lxml
    matplotlib
    numpy
    opencv-python
    pymavlink
    pynmeagps
    pyserial
    setuptools # Imports `pkg_resources` at runtime
    wxpython
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    billiard
    gnureadline
  ];

  pythonImportsCheck = [ "MAVProxy" ];

  # No tests, but we can check the version
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "MAVLink proxy and command line ground station";
    mainProgram = "mavproxy.py";
    homepage = "https://github.com/ArduPilot/MAVProxy";
    changelog = "https://github.com/ArduPilot/MAVProxy/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lopsided98 ];
  };
}
