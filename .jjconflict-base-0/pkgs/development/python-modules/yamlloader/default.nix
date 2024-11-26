{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pyyaml,
  hypothesis,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tv5A7PWvWW2EDpIGcO00dfmBNJK/blWyTyrUUMISurU=";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "yaml"
    "yamlloader"
  ];

  meta = with lib; {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
    changelog = "https://github.com/Phynix/yamlloader/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
