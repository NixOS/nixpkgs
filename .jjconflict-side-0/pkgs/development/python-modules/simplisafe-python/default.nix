{
  lib,
  aiohttp,
  aresponses,
  backoff,
  beautifulsoup4,
  buildPythonPackage,
  certifi,
  docutils,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pytz,
  types-pytz,
  voluptuous,
  websockets,
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "2024.01.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "simplisafe-python";
    tag = version;
    hash = "sha256-ewbR2FI0t2F8HF0ZL5omsclB9OPAjHygGLPtSkVlvgM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    beautifulsoup4
    certifi
    docutils
    pytz
    voluptuous
    websockets
  ];

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  disabledTests = [
    # simplipy/api.py:253: InvalidCredentialsError
    "test_request_error_failed_retry"
    "test_update_error"
    # ClientConnectorError: Cannot connect to host auth.simplisafe.com:443 ssl:default [Temporary failure in name resolution]
    "test_client_async_from_refresh_token_unknown_error"
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [ "simplipy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/bachya/simplisafe-python/releases/tag/${version}";
    description = "Python library the SimpliSafe API";
    homepage = "https://simplisafe-python.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
