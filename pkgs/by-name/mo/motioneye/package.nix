{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "motioneye";
  version = "0.44.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "motioneye-project";
    repo = "motioneye";
    tag = version;
    hash = "sha256-4sXttSSkmMgsoZb7PXEXXh8KNORTSmqq4lYp3JBDmPo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    babel
    boto3
    jinja2
    pillow
    pycurl
    tornado
    argon2-cffi
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "motioneye"
  ];

  meta = {
    description = "Web frontend for the motion daemon";
    homepage = "https://github.com/motioneye-project/motioneye";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
