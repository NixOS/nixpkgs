{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  typesense,
  curl,
  faker,
  httpx,
  isort,
  pytest-asyncio,
  pytest-httpx,
  pytest-mock,
  python-dotenv,
  requests-mock,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "typesense";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typesense";
    repo = "typesense-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GzapEl26FS6yMGeLC54y9ysl0mt9l6ceYHr84E6BqBo=";
  };

  patches = [
    # See <https://github.com/typesense/typesense-python/pull/103>.
    ./0001-linux-only-metrics.patch
    ./0002-generated-temp-path.patch
    ./0003-tests-fix-endpoint-path.patch
    ./0004-tests-fix-rule_id.patch
    ./0005-tests-fix-removed-fields.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    typesense
    curl
    faker
    httpx
    isort
    pytest-asyncio
    pytest-httpx
    pytest-mock
    python-dotenv
    requests-mock
    respx
  ];
  disabledTestMarks = [ "open_ai" ];
  disabledTests = [ "import_typing_extensions" ];

  __darwinAllowLocalNetworking = true;

  pytestFlags = [ "-vv" ];

  preCheck = ''
    TYPESENSE_API_KEY="xyz" \
    TYPESENSE_DATA_DIR="$(mktemp -d)" \
    typesense-server &

    typesense_pid=$!

    # Wait for typesense to finish starting.
    timeout 20 bash -c '
      while ! curl -s --fail localhost:8108/health; do sleep 1; done
    ' || false
  '';
  postCheck = ''
    kill $typesense_pid
  '';

  pythonImportsCheck = [ "typesense" ];

  meta = {
    description = "Python client for Typesense, an open source and typo tolerant search engine";
    homepage = "https://github.com/typesense/typesense-python";
    license = lib.licenses.asl20;
    teams = [ lib.teams.ngi ];
  };
})
