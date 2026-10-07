{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,
  matplotlib,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spectral_derivatives";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pavelkomarov";
    repo = "spectral-derivatives";
    tag = "v${version}";
    hash = "sha256-KSx3aW2DgVr1nhtGqIO85s6c5p+1rjnrpMY4e63LLiE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "specderiv" ];

  meta = {
    description = "Derivatives by spectral methods";
    license = lib.licenses.bsd3;
    homepage = "https://pavelkomarov.com/spectral-derivatives/specderiv.html";
    maintainers = with lib.maintainers; [ conny ];
  };
}
