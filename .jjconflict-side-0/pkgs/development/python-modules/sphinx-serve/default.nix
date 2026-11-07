{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sphinx-serve";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jZD2WVEUEIUAsfk10/TQe/UZJ4PGfOg/lE7yiQmWack=";
  };

  doCheck = false; # No tests

  pythonImportsCheck = [ "sphinx_serve" ];

  meta = {
    description = "Spawns a simple HTTP server to preview your sphinx documents";
    mainProgram = "sphinx-serve";
    homepage = "https://github.com/tlatsas/sphinx-serve";
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    license = lib.licenses.mit;
  };
}
