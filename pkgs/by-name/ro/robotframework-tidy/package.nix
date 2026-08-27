{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "robotframework-tidy";
  version = "4.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-tidy";
    tag = finalAttrs.version;
    hash = "sha256-WAuB+kTEZAG1uVEXVY1CdIDGeRRHo5AT1bHs8/wBBcc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonRelaxDeps = [ "rich_click" ];

  dependencies = with python3.pkgs; [
    robotframework
    click
    colorama
    pathspec
    tomli
    rich-click
    jinja2
    tomli-w
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  # click 8.3.x regression breaks `--list` / `--generate-config` optional-value flags (pallets/click#3130)
  disabledTestPaths = [
    "tests/utest/test_cli.py::TestCli::test_list_transformers[4---list]"
    "tests/utest/test_cli.py::TestCli::test_list_transformers[4--l]"
    "tests/utest/test_cli.py::TestCli::test_list_transformers[5---list]"
    "tests/utest/test_cli.py::TestCli::test_list_transformers[5--l]"
    "tests/utest/test_cli.py::TestCli::test_list_transformers[None---list]"
    "tests/utest/test_cli.py::TestCli::test_list_transformers[None--l]"
    "tests/utest/test_cli.py::TestCli::test_list_no_config"
    "tests/utest/test_cli.py::TestGenerateConfig::test_generate_default_config"
    "tests/utest/test_cli.py::TestGenerateConfig::test_generate_config_ignore_existing_config"
    "tests/utest/test_cli.py::TestGenerateConfig::test_generate_config_with_cli_config"
    "tests/utest/test_cli.py::TestGenerateConfig::test_missing_dependency"
  ];

  meta = {
    description = "Code autoformatter for Robot Framework";
    homepage = "https://robotidy.readthedocs.io";
    changelog = "https://github.com/MarketSquare/robotframework-tidy/blob/main/docs/releasenotes/${finalAttrs.src.tag}.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "robotidy";
  };
})
