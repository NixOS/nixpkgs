{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "phase-cli";
  version = "1.18.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phasehq";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-ggxTXI3NUHiK1aJqy19rgDlbZxPfGxnqvIlh3NVi9BY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    keyring
    questionary
    cffi
    requests
    pynacl
    rich
    pyyaml
    toml
    python-hcl2
  ];

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/*.py"
  ];

  pythonRelaxDeps = true;

  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Securely manage and sync environment variables with Phase";
    homepage = "https://github.com/phasehq/cli";
    changelog = "https://github.com/phasehq/cli/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "phase";
  };
}
