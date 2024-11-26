{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-testing";
  version = "5.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.testing";
    inherit version;
    hash = "sha256-6HzQ2NZmVzza8TOBare5vuyAGmSoZZXBnLX+mS7z1kk=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = !isPyPy;

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "src/zope/testing/tests.py" ];

  pythonImportsCheck = [ "zope.testing" ];

  pythonNamespaces = [ "zope" ];

  meta = with lib; {
    description = "Zope testing helpers";
    homepage = "https://github.com/zopefoundation/zope.testing";
    changelog = "https://github.com/zopefoundation/zope.testing/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
