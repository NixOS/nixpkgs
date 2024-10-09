{
  lib,
  awscli,
  fetchFromGitHub,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: { sqlalchemy = super.sqlalchemy_1_4; };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pacu";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "pacu";
    rev = "refs/tags/v${version}";
    hash = "sha256-Td5H4O6/7Gh/rvP191xjCJmIbyc4ezZC5Fh4FZ39ZUM=";
  };

  pythonRelaxDeps = [
    "dsnap"
    "sqlalchemy-utils"
    "sqlalchemy"
    "pycognito"
    "urllib3"
  ];

  build-system = with python.pkgs; [ poetry-core ];


  dependencies =
    [ awscli ]
    ++ (with python.pkgs; [
      awscli
      boto3
      botocore
      chalice
      dsnap
      jq
      policyuniverse
      pycognito
      pyyaml
      qrcode
      requests
      sqlalchemy
      sqlalchemy-utils
      toml
      typing-extensions
      urllib3
    ]);

  nativeCheckInputs = with python.pkgs; [
    moto
    pytestCheckHook
  ];

  postBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pacu" ];

  disabledTests = [
    # sAttributeError: module 'moto' has no attribute 'mock_s3'
    "test_update"
    "test_update_second_time"
  ];

  meta = with lib; {
    description = "AWS exploitation framework";
    homepage = "https://github.com/RhinoSecurityLabs/pacu";
    changelog = "https://github.com/RhinoSecurityLabs/pacu/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pacu";
  };
}
