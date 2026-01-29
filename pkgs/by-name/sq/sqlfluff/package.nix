{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sqlfluff";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlfluff";
    repo = "sqlfluff";
    tag = finalAttrs.version;
    hash = "sha256-hXiy3PGoBe6O9FaACN31Tss3xMBfiw4YuVLxbGi+/tA=";
  };

  pythonRelaxDeps = [ "click" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
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
  ];

  nativeCheckInputs = with python3Packages; [
    hypothesis
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

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
    changelog = "https://github.com/sqlfluff/sqlfluff/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sqlfluff";
  };
})
