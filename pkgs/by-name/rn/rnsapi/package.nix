{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rnsapi";
  version = "0-unstable-2026-07-09";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "attermann";
    repo = "ReticulumAPI";
    rev = "1f20cf5d2f00894389c864d1e018d771191a9809";
    hash = "sha256-IB67sLjOlaiAI8089ODAUNZRahvhLuiOxdGZ+4B24IE=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    aiohttp
    cryptography
    rns
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-aiohttp
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [
    "rnsapi"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "REST + WebSocket API daemon that exposes the full Reticulum Network Stack (RNS) service over HTTP(S) and WS(S)";
    homepage = "https://github.com/attermann/ReticulumAPI";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rnsapid";
  };
})
