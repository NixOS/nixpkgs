{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pylint,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools-lint";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "setuptools-lint";
    inherit (finalAttrs) version;
    hash = "sha256-55ThXHyN3pcLYY2cetRYiurqBn8DTMtK6PrMYwtTQZk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pylint ];

  pythonImportsCheck = [ "setuptools_lint" ];

  meta = {
    description = "Package to expose pylint as a lint command into setup.py";
    homepage = "https://github.com/johnnoone/setuptools-pylint";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ nickhu ];
  };
})
