{
  lib,
  aiofiles,
  aiohttp,
  aiolimiter,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  protobuf,
  setuptools,
  tesla-protocol,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "tesla-fleet-api";
  version = "1.17.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-tesla-fleet-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EtnmGkVUHLA7Bvv/kU47ja0RRl3y4x7xFe7oJ8mdjnI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    aiolimiter
    bleak
    bleak-retry-connector
    cryptography
    protobuf
    tesla-protocol
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tesla_fleet_api" ];

  meta = {
    description = "Python library for Tesla Fleet API and Teslemetry";
    homepage = "https://github.com/Teslemetry/python-tesla-fleet-api";
    changelog = "https://github.com/Teslemetry/python-tesla-fleet-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
