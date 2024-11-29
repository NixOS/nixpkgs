{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  packaging,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-bsblan";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    rev = "refs/tags/v${version}";
    hash = "sha256-mOVX65YRDUac0GoB9+tHIYtvNDGyxT0BSsj8I3OzuBI=";
  };

  postPatch = ''
    sed -i "/ruff/d" pyproject.toml
  '';

  env.PACKAGE_VERSION = version;

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    backoff
    mashumaro
    orjson
    packaging
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bsblan" ];

  meta = with lib; {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    changelog = "https://github.com/liudger/python-bsblan/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
