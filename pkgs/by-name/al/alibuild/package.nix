{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "alibuild";
  version = "1.17.28";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x+1sAFJzKBUwVy5uIR/EVKicVGY5q6ghFiN175vN4VE=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = with python3Packages; [ pip ];

  dependencies = with python3Packages; [
    requests
    pyyaml
    boto3
    jinja2
    distro
  ];

  pythonRelaxDeps = [ "boto3" ];

  doCheck = false;

  meta = {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ktf ];
  };
}
