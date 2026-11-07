{
  lib,
  brotli,
  buildPythonPackage,
  fastmcp,
  fetchFromGitHub,
  h2,
  httpx,
  ijson,
  isal,
  nix-update-script,
  opentelemetry-api,
  orjson,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  respx,
  stream-unzip,
  typing-extensions,
  typing-inspection,
  uv-build,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "vulners";
  version = "4.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vulnersCom";
    repo = "api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SoU1I+3ERHCKrsb4ej+X5JIoaoWtGyJCXw1rnQ6MeNk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.29,<0.12" "uv_build"
  '';

  pythonRelaxDeps = [
    "h2"
    "typing-inspection"
  ];

  build-system = [ uv-build ];

  dependencies = [
    brotli
    h2
    httpx
    ijson
    isal
    orjson
    pydantic
    stream-unzip
    typing-extensions
    typing-inspection
    zstandard
  ];

  optional-dependencies = {
    mcp = [
      fastmcp
    ];
    otel = [
      opentelemetry-api
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "vulners" ];

  disabledTestPaths = [
    # Smoke tests are failing
    "tests/test_smoke.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python SDK for the Vulners vulnerability-intelligence API";
    homepage = "https://github.com/vulnersCom/api";
    changelog = "https://github.com/vulnersCom/api/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
