{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "infisicalsdk";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Infisical";
    repo = "python-sdk-official";
    tag = "v${version}";
    hash = "sha256-k4yJ1o3OOt01vXCfWDZ1zUtr/yoMSg43QzKUG9V/NGA=";
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
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
}
