{
  aiohomematic,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-slugify,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-loom-client";
  version = "2026.9.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-client";
    tag = finalAttrs.version;
    hash = "sha256-tDFXRxAF0UvQV1QHShTYw3rx9h7Eye1+M2OkeN2zOCg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohomematic
    aiohttp
    pydantic
    python-slugify
  ];

  pythonImportsCheck = [ "openccu_loom_client" ];

  nativeCheckInputs = [
    gitMinimal
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/SukramJ/openccu-loom-client/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Async Python REST + WebSocket client for the openccu-loom daemon";
    homepage = "https://github.com/SukramJ/openccu-loom-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
