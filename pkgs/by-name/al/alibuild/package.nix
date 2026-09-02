{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "alibuild";
  version = "1.17.43";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-d/eag9686TSEqJsYnVmwF99vqIjTKoi6tZxhI6s0wak=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]>=6.2,<10" "setuptools_scm"
  '';

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
    changelog = "https://github.com/alisw/alibuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ktf ];
  };
})
