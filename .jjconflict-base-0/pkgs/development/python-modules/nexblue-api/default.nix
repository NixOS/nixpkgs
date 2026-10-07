{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "nexblue-api";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "NexBlue-AB";
    repo = "nexblue-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y9GDSI98n79Kob/Wpxihdi6EK9/bd1wqbpHPYV0vVzA=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nexblue_api" ];

  meta = {
    description = "Async client for the NexBlue OpenAPI";
    homepage = "https://github.com/NexBlue-AB/nexblue-api";
    changelog = "https://github.com/NexBlue-AB/nexblue-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
