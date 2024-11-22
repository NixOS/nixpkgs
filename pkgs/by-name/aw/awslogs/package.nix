{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "awslogs";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = pname;
    rev = version;
    sha256 = "sha256-o6xZqwlqAy01P+TZ0rB5rpEddWNUBzzHp7/cycpcwes=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    boto3
    termcolor
    python-dateutil
    docutils
    setuptools
    jmespath
  ];


  postPatch = ''
    substituteInPlace setup.py \
      --replace "boto3>=1.34.75" "boto3>=1.34.58" \
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "awslogs"
  ];

  meta = with lib; {
    description = "AWS CloudWatch logs for Humans";
    mainProgram = "awslogs";
    homepage = "https://github.com/jorgebastida/awslogs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dbrock ];
  };
}
