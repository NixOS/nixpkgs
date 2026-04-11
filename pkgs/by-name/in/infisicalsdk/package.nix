{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "infisicalsdk";
  version = "1.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Infisical";
    repo = "python-sdk-official";
    tag = "v${version}";
    hash = "sha256-2bfT99ynl14CSbqIOG2SMQb3oW+uAWD+iJifdMQG8CE=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    python-dateutil
    aenum
    requests
    boto3
    botocore
  ];

  doCheck = false;
  pythonImportsCheck = [ "infisical_sdk" ];

  meta = {
    homepage = "https://github.com/Infisical/python-sdk-official";
    description = "Infisical Python SDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
}
