{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "octosuite";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bellingcat";
    repo = "octosuite";
    tag = version;
    hash = "sha256-bgTAGIJbxOa8q8lMsWa8dHwNZ/jXiWGQOp921sd2Vdo=";
  };

  postPatch = ''
    # pyreadline3 is Windows-only
    substituteInPlace pyproject.toml \
      --replace-fail '"pyreadline3",' ""
  '';

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    psutil
    requests
    rich
  ];

  pythonImportsCheck = [
    "octosuite"
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Advanced Github OSINT framework";
    mainProgram = "octosuite";
    homepage = "https://github.com/bellingcat/octosuite";
    changelog = "https://github.com/bellingcat/octosuite/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
