{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = "pinnwand";
    tag = "v${version}";
    hash = "sha256-oB7Dd1iVzGqr+5nG7BfZuwOQUgUnmg6ptQDZPGH7P5E=";
  };

  build-system = [ pdm-pep517 ];

  dependencies = [
    click
    docutils
    pygments
    pygments-better-html
    python-dotenv
    sqlalchemy
    token-bucket
    tomli
    tornado
  ];

  nativeCheckInputs = [
    gitpython
    pytest-asyncio
    pytest-cov-stub
    pytest-html
    pytest-playwright
    pytestCheckHook
    toml
    urllib3
  ];

  disabledTestPaths = [
    # out-of-date browser tests
    "test/e2e"
    # click 8.2.0 exits with 2 instead of 0 when no args are passed
    "test/integration/test_command.py::test_main"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    changelog = "https://github.com/supakeen/pinnwand/releases/tag/v${version}";
    description = "Python pastebin that tries to keep it simple";
    homepage = "https://github.com/supakeen/pinnwand";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "pinnwand";
    platforms = platforms.linux;
  };
}
