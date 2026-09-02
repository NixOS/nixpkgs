{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apm-cli";
  version = "0.29.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "apm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0aVqPRRaVjV3qoE+Fh3L98HUmBlAtu3pMiTSxVDj4Ak=";
  };

  pythonRemoveDeps = [
    # Not in nixpkgs and the game is not worth the candle for this package.
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
      jsonschema
      mypy
      pylint
      pytest
      pytest-cov
      pytest-split
      pytest-xdist
      ruff
    ];
  };

  pythonImportsCheck = [
    "apm_cli"
  ];

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    changelog = "https://github.com/microsoft/apm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "apm-cli";
  };
})
