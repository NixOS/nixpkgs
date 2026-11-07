{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "yacs";
  version = "0.1.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rbgirshick";
    repo = "yacs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nO8FL4tTkfTthXYXxXORLieFwvn780DDxfrxC9EUUJ0=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "yacs" ];
  checkPhase = ''
    ${python.interpreter} yacs/tests.py
  '';

  meta = {
    description = "Yet Another Configuration System";
    homepage = "https://github.com/rbgirshick/yacs";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
