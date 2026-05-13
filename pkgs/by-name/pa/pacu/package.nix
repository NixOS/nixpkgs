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
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pacu";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "pacu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hrks6mvvmmdCMxprB/SPlkfcSu6uyoEVtb0eUD3CALo=";
  };

  pythonRelaxDeps = [
    "dsnap"
    "sqlalchemy-utils"
    "sqlalchemy"
    "pycognito"
    "qrcode"
    "urllib3"
  ];

  build-system = with python.pkgs; [ poetry-core ];

  dependencies = [
    awscli
  ]
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
    types-urllib3
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

    # AttributeError: module 'moto' has no attribute 'mock_cognitoidp'
    "test_cognito__attack_minimal"
    "test_cognito__attack_sanity"
  ];

  meta = {
    description = "AWS exploitation framework";
    homepage = "https://github.com/RhinoSecurityLabs/pacu";
    changelog = "https://github.com/RhinoSecurityLabs/pacu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pacu";
  };
})
