{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorama" ];

  meta = with lib; {
    description = "Cross-platform colored terminal text";
    homepage = "https://github.com/tartley/colorama";
    changelog = "https://github.com/tartley/colorama/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
