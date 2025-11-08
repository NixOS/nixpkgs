{
  lib,
  gitUpdater,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "legendary-gl"; # Name in pypi
  version = "0.20.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "56d439ed2d3d9f34e2b08fa23e627c23a487b8d6";
    hash = "sha256-yCHeeEGw+9gtRMGyIhbStxJhmSM/1Fqly7HSRDkZILQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    filelock
  ];

  disabled = python3Packages.pythonOlder "3.8";

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "legendary" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Free and open-source Epic Games Launcher alternative";
    homepage = "https://github.com/derrod/legendary";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ equirosa ];
    mainProgram = "legendary";
  };
}
