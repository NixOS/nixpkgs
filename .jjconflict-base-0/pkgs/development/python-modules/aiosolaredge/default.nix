{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  yarl,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiosolaredge";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiosolaredge";
    rev = "refs/tags/v${version}";
    hash = "sha256-1C74U5HWDTJum1XES21t1uIJwm0YW3l041mwvqY/dA4=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "aiosolaredge" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/bdraco/aiosolaredge/blob/${src.rev}/CHANGELOG.md";
    description = "Asyncio SolarEdge API client";
    homepage = "https://github.com/bdraco/aiosolaredge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
