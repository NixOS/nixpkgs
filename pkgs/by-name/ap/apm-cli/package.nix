{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
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

  postPatch = ''
    # The wheel does not include scripts/, so RuntimeManager's
    # repository-relative fallback does not work after installation.
    substituteInPlace src/apm_cli/runtime/manager.py \
      --replace-fail 'repo_root = current_file.parent.parent.parent.parent  # Go up to repo root' 'repo_root = Path("${placeholder "out"}/share/apm-cli")'
  '';

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

  postInstall = ''
    install -Dm755 -t "$out/share/apm-cli/scripts/runtime" scripts/runtime/*
    install -Dm755 -t "$out/share/apm-cli/scripts" scripts/github-token-helper.sh
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  postInstallCheck = ''
        test -f "$out/share/apm-cli/scripts/runtime/setup-common.sh"
        test -f "$out/share/apm-cli/scripts/github-token-helper.sh"

        ${python3Packages.python.interpreter} - <<'PY'
    from apm_cli.runtime.manager import RuntimeManager

    manager = RuntimeManager()

    assert manager.get_common_script()
    assert manager.get_token_helper_script()

    for runtime_info in manager.supported_runtimes.values():
        assert manager.get_embedded_script(runtime_info["script"])
    PY
  '';

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    changelog = "https://github.com/microsoft/apm/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "apm";
  };
})
