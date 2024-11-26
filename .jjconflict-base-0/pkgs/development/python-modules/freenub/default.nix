{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  cbor2,
  pycryptodomex,
  busypie,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "freenub";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "freenub";
    rev = "refs/tags/v${version}";
    hash = "sha256-UkW/7KUQ4uCu3cxDSL+kw0gjKjs4KnmxRIOLVP4hwyA=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cbor2
    pycryptodomex
    requests
  ];

  nativeCheckInputs = [
    busypie
    pytest-asyncio
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = with lib; {
    description = "Fork of pubnub";
    homepage = "https://github.com/bdraco/freenub";
    changelog = "https://github.com/bdraco/freenub/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
