{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gitlint";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    tag = "v${version}";
    hash = "sha256-4SGkkC4LjZXTDXwK6jMOIKXR1qX76CasOwSqv8XUrjs=";
  };

  # Upstream split the project into gitlint and gitlint-core to
  # simplify the dependency handling
  sourceRoot = "${src.name}/gitlint-core";

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    arrow
    click
    sh
  ];

  nativeCheckInputs = [
    gitMinimal
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [
    "gitlint"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linting for your git commit messages";
    homepage = "https://jorisroovers.com/gitlint/";
    changelog = "https://github.com/jorisroovers/gitlint/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ethancedwards8
      fab
      matthiasbeyer
    ];
    mainProgram = "gitlint";
  };
}
