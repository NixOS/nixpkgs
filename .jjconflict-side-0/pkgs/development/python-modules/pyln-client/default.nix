{
  lib,
  buildPythonPackage,
  hatchling,
  pyln-bolt7,
  pyln-proto,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pyln-client";
  pyproject = true;

  inherit (pyln-proto) src version;

  postUnpack = ''
    sourceRoot=$sourceRoot/contrib/pyln-client
  '';

  build-system = [ hatchling ];

  dependencies = [
    pyln-bolt7
    pyln-proto
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "pyln" ];

  pythonImportsCheck = [ "pyln.client" ];

  meta = {
    description = "Client and plugin library for Core Lightning";
    homepage = "https://github.com/ElementsProject/lightning/tree/master/contrib/pyln-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
