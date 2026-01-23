{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.12.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "litecli";
    rev = "v${version}";
    hash = "sha256-TPwzXfb4n6wTe6raQ5IowKdhGkKrf2pmSS2+Q03NKYk=";
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
    mainProgram = "litecli";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = "https://litecli.com";
    changelog = "https://github.com/dbcli/litecli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}
