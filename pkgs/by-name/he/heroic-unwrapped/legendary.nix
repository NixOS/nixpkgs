{
  lib,
  gitUpdater,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "legendary-heroic";
  version = "0.20.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "legendary";
    tag = version;
    hash = "sha256-zX5Lyj8IDHETFyEpUaFnGaYZVs1hDy9rtwab1+rNlrw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    requests-futures
    filelock
  ];

  pythonImportsCheck = [ "legendary" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Free and open-source Epic Games Launcher alternative";
    longDescription = ''
      This is the Heroic Games Launcher's fork of legendary.
    '';
    homepage = "https://github.com/Heroic-Games-Launcher/legendary";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    mainProgram = "legendary";
  };
}
