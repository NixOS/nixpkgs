{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apm-cli";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "apm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3rMTcqLq/mjOaXUS4/9LRI1vvoi3ad8gIMyCZmGOCPg=";
  };

  pythonRelaxDeps = [
    "websockets"
  ];

  pythonRemoveDeps = [
    # Not packaged in nixpkgs.
    "llm-github-models"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    colorama
    filelock
    gitpython
    llm
    python-frontmatter
    pyyaml
    requests
    rich
    rich-click
    ruamel-yaml
    toml
    tomlkit
    truststore
    watchdog
    websockets
  ];

  optional-dependencies = with python3Packages; {
    build = [
      pyinstaller
    ];
    dev = [
      hypothesis
      jsonschema
      mypy
      # Not packaged in nixpkgs.
      # mutmut
      pylint
      pytest
      pytest-cov
      # Not packaged in nixpkgs.
      # pytest-split
      pytest-xdist
      ruff
    ];
  };

  pythonImportsCheck = [
    "apm_cli"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    changelog = "https://github.com/microsoft/apm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "apm";
  };
})
