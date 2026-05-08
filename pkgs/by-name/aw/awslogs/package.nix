{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "awslogs";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = "awslogs";
    tag = finalAttrs.version;
    sha256 = "sha256-o6xZqwlqAy01P+TZ0rB5rpEddWNUBzzHp7/cycpcwes=";
  };

  propagatedBuildInputs = with python3Packages; [
    boto3
    termcolor
    python-dateutil
    docutils
    setuptools
    jmespath
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "boto3>=1.34.75" "boto3>=1.34.58"
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "awslogs"
  ];

  meta = {
    description = "AWS CloudWatch logs for Humans";
    mainProgram = "awslogs";
    homepage = "https://github.com/jorgebastida/awslogs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dbrock ];
  };
})
