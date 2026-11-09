{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jiratui";
  version = "1.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whyisdifficult";
    repo = "jiratui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NVgvCgcEfxS1kQug2dTvkpOdZFxITBKnE9v6Ga6q3s0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.5,<0.13.0" "uv_build>=0.12.5"
  '';

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies =
    with python3Packages;
    [
      click
      gitpython
      httpx
      marklas
      puremagic
      pydantic-settings
      python-dateutil
      python-json-logger
      pyyaml
      questionary
      textual
      textual-autocomplete
      textual-image
      urllib3
      xdg-base-dirs
    ]
    ++ textual.optional-dependencies.syntax;

  pythonRelaxDeps = [
    "click"
    "python-json-logger"
    "textual-image"
    # Unused dependency: https://github.com/whyisdifficult/jiratui/pull/402
    "urllib3"
  ];

  pythonImportsCheck = [
    "jiratui"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  # --version creates config dir, but versionCheckHook swallows env by default.
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "A Textual User Interface for interacting with Atlassian Jira from your shell";
    homepage = "https://github.com/whyisdifficult/jiratui";
    changelog = "https://github.com/whyisdifficult/jiratui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "jiratui";
  };
})
