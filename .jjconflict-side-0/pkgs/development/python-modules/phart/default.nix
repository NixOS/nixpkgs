{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  networkx,
  numpy,
  pytestCheckHook,
  pytest-cov-stub,
  pydot,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "phart";
  version = "2.1.0";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-t9hna8eZReHKtho/mniLOVgG1j5sRYFDGD3on2v3x2M=";
  };

  pyproject = true;

  build-system = [
    hatchling
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  dependencies = [
    networkx
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pytest-cov-stub
    pydot
  ];

  pythonImportsCheck = [
    "phart"
  ];

  meta = {
    description = "Python Hierarchical ASCII Representation Tool";
    homepage = "https://github.com/scottvr/phart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
    broken = !pythonAtLeast "3.14";
  };
})
