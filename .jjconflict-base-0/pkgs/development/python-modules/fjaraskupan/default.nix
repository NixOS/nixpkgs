{
  lib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fjaraskupan";
  version = "2.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "fjaraskupan";
    tag = version;
    hash = "sha256-IKi2kaypwHdK9w+FZlWrreUXBgBgg4y3D8bSJhKHSYo=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fjaraskupan" ];

  meta = with lib; {
    description = "Module for controlling Fjäråskupan kitchen fans";
    homepage = "https://github.com/elupus/fjaraskupan";
    changelog = "https://github.com/elupus/fjaraskupan/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
