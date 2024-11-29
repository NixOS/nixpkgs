{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "intbitset";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wUHtqhwXuRwph1N+Jp2VWra9w5Zq89624eDSDtvQndI=";
  };

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "intbitset" ];

  meta = {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    changelog = "https://github.com/inveniosoftware-contrib/intbitset/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
