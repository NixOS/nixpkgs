{
  lib,
  awscli,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pacu";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "pacu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sW2ZfrlZiK29ON9TJLAg/YHnhM8ZtWBGCiAEQ5FIWHA=";
  };

  pythonRelaxDeps = [
    "dsnap"
    "botocore" # constrained in https://github.com/RhinoSecurityLabs/pacu/pull/498 to fix moto issues (mocking)
    "pycognito"
    "qrcode"
    "urllib3"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = [
    awscli
  ]
  ++ (with python3.pkgs; [
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

  nativeCheckInputs = with python3.pkgs; [
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
