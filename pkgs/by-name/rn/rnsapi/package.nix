{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rnsapi";
  version = "0-unstable-2026-07-06";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "attermann";
    repo = "ReticulumAPI";
    rev = "9dc2a562c7e8695fb08c5204a403052a19af03d2";
    hash = "sha256-8WsQyJtxkXVaObBHQCQ2VrqJUApSyePL1IVUoTE4XPk=";
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
    mainProgram = "reticulum-api";
  };
})
