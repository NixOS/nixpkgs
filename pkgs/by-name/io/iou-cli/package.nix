{
  lib,
  python3Packages,
  fetchFromGitLab,
  versionCheckHook,
}:

python3Packages.buildPythonApplication {
  pname = "iou-cli";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "git.221b.uk";
    owner = "iou";
    repo = "cli-client";
    rev = "24e2ba4a08a89b3101e76258f14334cba52c4493";
    hash = "sha256-89pRwX3xYI4+FopsJut8+YdX2tbz/dzgX8MMlTtborA=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    authlib
    click
    cloup
    questionary
    requests
    rich
  ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytest
    pytest-cov
    pytestCheckHook
    mock
  ]);

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [
    "iou_cli"
  ];

  meta = {
    description = "Shared expense tracking and splitting. Client application.";
    homepage = "https://git.221b.uk/iou/cli-client";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      w4tsn
    ];
    mainProgram = "iou";
  };
}
