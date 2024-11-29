{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "airgradient";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "airgradienthq";
    repo = "python-airgradient";
    rev = "refs/tags/v${version}";
    hash = "sha256-al0DLsub3xLU1BWLNn0cMI87O0mcQJ0Y4Boj2Xwk1r0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "airgradient" ];

  meta = with lib; {
    description = "Module for AirGradient";
    homepage = "https://github.com/airgradienthq/python-airgradient";
    changelog = "https://github.com/airgradienthq/python-airgradient/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
