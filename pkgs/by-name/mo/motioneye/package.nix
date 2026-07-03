{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "motioneye";
  version = "0.43.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "motioneye-project";
    repo = "motioneye";
    tag = version;
    hash = "sha256-ckOgYmOP5irjNutcC3FMZPBexn/CldG0UtFZ+tPYNJ4=";
  };

  patches = [
    # fix pytest
    # https://github.com/motioneye-project/motioneye/pull/3271
    (fetchpatch {
      url = "https://github.com/motioneye-project/motioneye/commit/41c0727e2872af1b758743c41b529e76dcac6f84.patch";
      hash = "sha256-0zDveoAN1T0SuCob0U/9GEGTh7pj2CXH/j4YrjO0VE0=";
      includes = [ "conftest.py" ];
    })
  ];

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
