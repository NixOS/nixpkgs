{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "litecli";
  version = "1.17.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "litecli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YSPNtDL5rNgRh5lJBKfL1jjWemlmf3eesBMSLyJVRLY=";
  };

  dependencies =
    with python3Packages;
    [
      cli-helpers
      click
      configobj
      prompt-toolkit
      pygments
      sqlparse
    ]
    ++ cli-helpers.optional-dependencies.styles;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "litecli" ];

  disabledTests = [
    "test_auto_escaped_col_names"
  ];

  meta = {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "litecli";
  };
})
