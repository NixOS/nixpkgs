{
  fetchFromGitHub,
  pkgs,
  python3Packages,
  lib,
}:
let
  version = "3.5.5";
  pname = "pros-cli";
in
python3Packages.buildPythonPackage {
  inherit pname version;
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
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
    pkgs.gcc-arm-embedded
  ];
  src = fetchFromGitHub {
    owner = "purduesigbots";
    repo = "pros-cli";
    tag = version;
    hash = "sha256-Lw3NJaFmJFt0g3N+jgmGLG5AMeMB4Tqk3d4mPPWvC/c=";
  };
  meta =
    let
      downloadPage = "https://github.com/purduesigbots/pros-cli/releases/tag/3.5.5";
    in
    with lib;
    {
      homepage = "https://pros.cs.purdue.edu/v5/index.html";
      inherit downloadPage;
      changelog = downloadPage;
      license = licenses.mpl20;
      maintainer = maintainers.maningreen;
      description = "Purdue University's Command Line Interface for managing PROS projects.";
      longDescription = ''
        Purdue University's Command Line Interface for managing PROS projects.
        Works with V5 and the Cortex.
      '';
      mainProgram = "pros";
    };
}
