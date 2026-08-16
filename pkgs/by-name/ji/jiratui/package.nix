{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jiratui";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whyisdifficult";
    repo = "jiratui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c+ycttouo6LZr1jaJ9lrS2aAODfsTRNhxyL4o4nqc/c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.2,<0.10.0" "uv_build>=0.9.2"
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
      textual
      textual-autocomplete
      textual-image
      urllib3
      xdg-base-dirs
    ]
    ++ textual.optional-dependencies.syntax;

  pythonRelaxDeps = [
    "click"
    "marklas"
    # upstream wants puremagic >= 2.2.0 but only uses puremagic.magic_string,
    # which is compatible with 1.x; drop once puremagic >= 2.2.0 lands
    "puremagic"
    "pydantic-settings"
    "python-json-logger"
  ];

  pythonImportsCheck = [
    "jiratui"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "A Textual User Interface for interacting with Atlassian Jira from your shell";
    homepage = "https://github.com/whyisdifficult/jiratui";
    changelog = "https://github.com/whyisdifficult/jiratui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "jiratui";
  };
})
