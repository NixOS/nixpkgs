{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gekko";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XX3Dgd/tRJssAewUZGA3roexL7LqFG2Cbi7iv4Snyk0=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "gekko" ];

  meta = {
    description = "Module for machine learning and optimization";
    homepage = "https://github.com/BYU-PRISM/GEKKO";
    changelog = "https://github.com/BYU-PRISM/GEKKO/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
