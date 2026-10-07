{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # build time
  setuptools-scm,

  # propagates
  aiohttp,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "uasiren";
  version = "0.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PaulAnnekov";
    repo = "uasiren";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NHrnG5Vhz+JZgcTJyfIgGz0Ye+3dFVv2zLCCqw2++oM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uasiren"
    "uasiren.client"
  ];

  meta = {
    changelog = "https://github.com/PaulAnnekov/uasiren/releases/tag/${finalAttrs.src.tag}";
    description = "Implements siren.pp.ua API - public wrapper for api.ukrainealarm.com API that returns info about Ukraine air-raid alarms";
    homepage = "https://github.com/PaulAnnekov/uasiren";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
