{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlfluff";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlfluff";
    repo = "sqlfluff";
    tag = version;
    hash = "sha256-fO4a1DCDM5RCeaPUHtPPGgTtZPRHOl9nuxbipDJZy7A=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      appdirs
      cached-property
      chardet
      click
      colorama
      configparser
      diff-cover
      jinja2
      oyaml
      pathspec
      platformdirs
      pytest
      regex
      tblib
      toml
      tqdm
      typing-extensions
    ]
    ++ lib.optionals (pythonOlder "3.8") [
      backports.cached-property
      importlib_metadata
    ];

  nativeCheckInputs = with python3.pkgs; [
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Don't run the plugin related tests
    "plugins/sqlfluff-plugin-example/test/rules/rule_test_cases_test.py"
    "plugins/sqlfluff-templater-dbt"
    "test/core/plugin_test.py"
    "test/diff_quality_plugin_test.py"
  ];

  disabledTests = [
    # dbt is not available yet
    "test__linter__skip_dbt_model_disabled"
    "test_rules__test_helper_has_variable_introspection"
    "test__rules__std_file_dbt"
    # Assertion failure
    "test_html_with_external_css"
  ];

  pythonImportsCheck = [ "sqlfluff" ];

  meta = {
    description = "SQL linter and auto-formatter";
    homepage = "https://www.sqlfluff.com/";
    changelog = "https://github.com/sqlfluff/sqlfluff/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sqlfluff";
  };
}
