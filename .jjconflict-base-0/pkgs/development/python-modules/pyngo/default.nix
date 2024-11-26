{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  django,
  pydantic,
  typing-extensions,

  # tests
  django-stubs,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyngo";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    rev = "refs/tags/${version}";
    hash = "sha256-qAq5e/B/gOBt9Wj8Kfhg+uTe/Sa/Qslk2g/o0+ttIag=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonRelaxDeps = [
    "pydantic"
    "typing-extensions"
  ];

  propagatedBuildInputs = [
    django
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "pyngo" ];

  nativeCheckInputs = [
    django-stubs
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    changelog = "https://github.com/yezz123/pyngo/releases/tag/${version}";
    description = "Pydantic model support for Django & Django-Rest-Framework";
    homepage = "https://github.com/yezz123/pyngo";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
