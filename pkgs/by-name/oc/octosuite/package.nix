{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "octosuite";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bellingcat";
    repo = "octosuite";
    tag = finalAttrs.version;
    hash = "sha256-Fliy9DR7K9gpGmGtl5r9AL+SmX8UpXisUc19T03dPHA=";
  };

  pythonRelaxDeps = [ "update-checker" ];

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    certifi
    pyfiglet
    questionary
    rich
    update-checker
  ];

  pythonImportsCheck = [ "octosuite" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Advanced GitHub OSINT framework";
    homepage = "https://github.com/bellingcat/octosuite";
    changelog = "https://github.com/bellingcat/octosuite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octosuite";
  };
})
