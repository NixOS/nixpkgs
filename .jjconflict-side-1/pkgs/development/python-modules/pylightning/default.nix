{
  lib,
  buildPythonPackage,
  setuptools,
  pyln-client,
}:

buildPythonPackage {
  pname = "pylightning";
  pyproject = true;

  # setup.py uses the version exported by pyln.client.
  inherit (pyln-client) src version;

  postUnpack = ''
    sourceRoot=$sourceRoot/contrib/pylightning
  '';

  build-system = [ setuptools ];

  dependencies = [ pyln-client ];

  # The compatibility package has no test suite.
  doCheck = false;

  pythonImportsCheck = [ "lightning" ];

  meta = {
    description = "Compatibility library for the Core Lightning Python client";
    homepage = "https://github.com/ElementsProject/lightning/tree/master/contrib/pylightning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
