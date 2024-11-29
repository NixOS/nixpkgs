{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  bleak,
  construct,
  construct-typing,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eq3btsmart";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EuleMitKeule";
    repo = "eq3btsmart";
    rev = "refs/tags/${version}";
    hash = "sha256-Z3GfUTh3qp5ICJAYsCO6ufw/Jd5FDjOaQE9SaD3H0IU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    construct
    construct-typing
  ];

  pythonImportsCheck = [ "eq3btsmart" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/EuleMitKeule/eq3btsmart/releases/tag/${version}";
    description = "Python library that allows interaction with eQ-3 Bluetooth smart thermostats";
    homepage = "https://github.com/EuleMitKeule/eq3btsmart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
