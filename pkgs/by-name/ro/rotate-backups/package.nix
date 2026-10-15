{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rotate-backups";
  version = "8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-rotate-backups";
    rev = version;
    hash = "sha256-fe6h6/0Rs87T6APzkctxith0vwpwj/v0zAMQCU/zjWQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    simpleeval
    update-dotdee
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/xolox/python-rotate-backups/issues/33
    "test_removal_command"
  ];

  meta = {
    description = "Simple command line interface for backup rotation";
    mainProgram = "rotate-backups";
    homepage = "https://github.com/xolox/python-rotate-backups";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
