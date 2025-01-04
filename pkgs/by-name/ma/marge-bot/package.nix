{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "marge-bot";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "marge-org";
    repo = "marge-bot";
    rev = version;
    hash = "sha256-2L7c/NEKyjscwpyf/5GtWXr7Ig14IQlRR5IbDYxp8jA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace-fail "--flake8 --pylint" ""
  '';

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    configargparse
    maya
    pyyaml
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    pendulum
  ];

  disabledTests = [
    # test broken when run under Nix:
    #   "unittest.mock.InvalidSpecError: Cannot spec a Mock object."
    "test_get_mr_ci_status"
    # broken because of an incorrect assertion:
    #   "AttributeError: 'has_calls' is not a valid assertion."
    "test_reapprove"
  ];

  disabledTestPaths = [
    # test errors due to API mismatch in test setup:
    #   "ImportError: cannot import name 'set_test_now' from 'pendulum.helpers'"
    "tests/test_interval.py"
  ];

  pythonImportsCheck = [ "marge" ];

  meta = with lib; {
    description = "Merge bot for GitLab";
    homepage = "https://gitlab.com/marge-org/marge-bot";
    changelog = "https://gitlab.com/marge-org/marge-bot/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "marge.app";
  };
}
