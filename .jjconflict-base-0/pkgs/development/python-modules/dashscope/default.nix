{
  # Basic
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  setuptools,
  # Dependencies
  aiohttp,
  requests,
  websocket-client,
  cryptography,
  certifi,
  typer,
  rich,
  httpx,
  httpx-sse,
  pyyaml,
  # Optional dependencies
  tiktoken,
  # Test
  pytestCheckHook,
  pytest-asyncio,
  pydantic,
  tenacity,
}:

buildPythonPackage rec {
  pname = "dashscope";
  version = "1.26.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dashscope";
    repo = "dashscope-sdk-python";
    tag = "v${version}";
    hash = "sha256-4plniNvpRNIUquTRDJZonQsa4inktGS7AluxKsX+Mpg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    websocket-client
    cryptography
    certifi
    typer
    rich
    httpx
    httpx-sse
    # Not listed in requirements.txt
    pyyaml
  ];

  optional-dependencies = {
    tokenizer = [ tiktoken ];
  };

  # Specify the version explicitly
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=get_version()," "version='${version}',"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pydantic
    tenacity
  ]
  ++ optional-dependencies.tokenizer;

  pythonImportsCheck = [ "dashscope" ];

  disabledTests = [
    # Needs network access and/or API key
    "TestAsyncImageSynthesisRequest"
    "TestAsyncRequest"
    "TestAsyncSessionLifecycle"
    "TestAsyncSessionUsage"
    "TestAsyncSessionWithDifferentMethods"
    "TestAsyncVideoSynthesisRequest"
    "TestEncryption"
    "TestSpeechRecognition"
    "TestSpeechTranscribe"
    "TestSynthesis"
    "TestWebSocketAsyncRequest"
    "TestWebSocketSyncRequest"
  ];

  meta = {
    description = "Python SDK for dashscope";
    homepage = "https://github.com/dashscope/dashscope-sdk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thattemperature ];
  };
}
