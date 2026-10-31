{
  fetchFromGitHub,
  gcc-arm-embedded,
  python3Packages,
  lib,
}:
let
  version = "3.5.5";
in
python3Packages.buildPythonApplication {

  inherit version;
  pname = "pros-cli";

  src = fetchFromGitHub {
    owner = "purduesigbots";
    repo = "pros-cli";
    tag = version;
    hash = "sha256-Lw3NJaFmJFt0g3N+jgmGLG5AMeMB4Tqk3d4mPPWvC/c=";
  };

  dependencies = with python3Packages; [
    setuptools
    wheel
    jsonpickle
    pyserial
    tabulate
    cobs
    click
    rich-click
    cachetools
    requests-futures
    semantic-version
    colorama
    pyzmq
    sentry-sdk
    pypng
    pyinstaller
    gcc-arm-embedded
  ];

  doCheck = false;

  meta = {
    homepage = "https://pros.cs.purdue.edu/v5/index.html";
    downloadPage = "https://github.com/purduesigbots/pros-cli/releases/";
    changelog = "https://github.com/purduesigbots/pros-cli/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.maningreen ];
    description = "Purdue University's Command Line Interface for managing PROS projects";
    longDescription = ''
      Purdue University's Command Line Interface for managing PROS projects.
      Works with V5 and the Cortex.
    '';
    mainProgram = "pros";
  };
}
