{ lib
, awscli
, fetchFromGitHub
, python3
}:


let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "pacu";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "pacu";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ty++jNJTk8YKy6Sl6xj1Xs25ZxJCeF9m/iwdA2fRXnI=";
  };

  pythonRelaxDeps = [
    "dsnap"
    "sqlalchemy-utils"
    "sqlalchemy"
    "urllib3"
  ];

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    awscli
  ] ++ (with python.pkgs; [
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

  pythonImportsCheck = [
    "pacu"
  ];

  disabledTests = [
    # sqlalchemy.exc.ArgumentError: Textual SQL expression
    #"test_migrations"
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
