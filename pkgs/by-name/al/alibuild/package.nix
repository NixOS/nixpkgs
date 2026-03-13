{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "alibuild";
  version = "1.17.41";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Tbl+lhjB2X979K+UyJyFF8+9XzPJkj94V9w1OIoltWI=";
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
})
